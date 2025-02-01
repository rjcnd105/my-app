{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    let

      devEnv = {
          PGPORT = builtins.getEnv "PGPORT";
          POSTGRES_USER = builtins.getEnv "POSTGRES_USER";
          POSTGRES_DB = builtins.getEnv "POSTGRES_DB";
          POSTGRES_PASSWORD = builtins.getEnv "POSTGRES_PASSWORD";
          LISTEN_ADDRESSES = builtins.getEnv "LISTEN_ADDRESSES";
      }; 
 
    in 

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.process-compose-flake.flakeModule
      ];
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      debug = true;

      perSystem =
        {
          self',
          system, 
          lib, 
          config,
          ...
        }:
        let
          pkgs = import nixpkgs {
            system = system;
            config = {
              allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "timescaledb"
                ];
            };
          };
    
        in
        # str = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "export ${n}=${v}") devEnv);
        {
          _module.args.pkgs = pkgs;
          packages.default = pkgs.mise;

          process-compose."app-services" =
          let 
          in 
          { config, lib, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services = {
                postgres."pg" = {
                  enable = true; 
                  package = pkgs.postgresql_17;
                  listen_addresses = devEnv.LISTEN_ADDRESSES;
                  port= lib.strings.toIntBase10 devEnv.PGPORT;
                  initialScript = {
                    before = ''
                      CREATE ROLE ${devEnv.POSTGRES_USER} WITH LOGIN PASSWORD '${devEnv.POSTGRES_PASSWORD}' SUPERUSER
                    '';
                  };
                };
                # environment = devEnv;
                
              };
              settings.processes.pgweb = {
                command = pkgs.pgweb;
                depends_on."pg".condition = "process_healthy";
                environment.PGWEB_DATABASE_URL = config.services.postgres.pg.connectionURI { dbName = devEnv.POSTGRES_DB; };
              };
            };

          devShells.default = config.process-compose."app-services".services.outputs.devShell;
          
        };
    };
}
