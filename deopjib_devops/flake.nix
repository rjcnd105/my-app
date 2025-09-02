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
      env = builtins.fromJSON (builtins.readFile ../.env-dev.json);
    in
    flake-parts.lib.mkFlake { inherit inputs self;  } {
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
          commonPackages =
            [ ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.inotify-tools
            ];
        in
        {
          _module.args.pkgs = pkgs;

          process-compose."app-services" =
            { config, lib, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services = {
                postgres."pg" = {
                  enable = true;
                  package = pkgs.postgresql_18;
                  listen_addresses = env.PGHOSTADDR;
                  dataDir = "${self}/.data/pg";

                  port = env.PGPORT;
                  settings = {
                     wal_level = "logical";
                  };
                  initialScript = {
                    before = ''
                      CREATE ROLE ${env.PGUSER} WITH LOGIN PASSWORD '${env.PGPASSWORD}' SUPERUSER;
                      CREATE DATABASE ${env.PGDATABASE};
                    '';
                  };
                };

              };
              settings.processes.pgweb =
                let
                  pgcfg = config.services.postgres.pg;
                in
                {
                  command = pkgs.pgweb;
                  depends_on."pg".condition = "process_healthy";
                  environment.PGWEB_DATABASE_URL = pgcfg.connectionURI {
                    dbName = env.PGDATABASE;
                  };
                };
            };

          devShells.default = pkgs.mkShell {
            packages = [ ] ++ commonPackages;
            inputsFrom = [
              config.process-compose."app-services".services.outputs.devShell
            ];
          };
        };
    };
}
