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
      PGPORT = builtins.getEnv "PGPORT";
      POSTGRES_USER = builtins.getEnv "POSTGRES_USER";
      POSTGRES_PASSWORD = builtins.getEnv "POSTGRES_PASSWORD";
      POSTGRES_DB = builtins.getEnv "POSTGRES_DB";
      LISTEN_ADDRESSES = builtins.getEnv "LISTEN_ADDRESSES";
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
          packages.default = pkgs.mise;
          _module.args.pkgs = pkgs;

          process-compose."app-services" =
            { config, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services = {
                postgres.pg = {
                  enable = true;
                  package = pkgs.postgresql_17;
                  listen_addresses = "*";
                  port = PGPORT;
                  initialScript = {
                    before = ''
                      CREATE ROLE ${POSTGRES_USER} WITH LOGIN PASSWORD '${POSTGRES_PASSWORD}' SUPERUSER;
                    '';
                  };
                };
              };
            };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.process-compose."app-services".services.outputs.devShell
            ];
            buildInputs =
              with pkgs;
              [
                postgresql_17
                caddy
              ]
              ++ lib.optional stdenv.isLinux inotify-tools
              ++ (lib.optionals stdenv.isDarwin (
                with darwin.apple_sdk.frameworks;
                [
                  CoreFoundation
                  CoreServices
                ]
              ));

            shellHook = ''
              echo "hello ${PGPORT}"
            '';
          };
        };
    };
}
