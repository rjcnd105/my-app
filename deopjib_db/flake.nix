{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/b599843bad24621dcaa5ab60dac98f9b0eb1cabe";
    flake-parts.url = "github:hercules-ci/flake-parts";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
     inputs@{
      self,
      nixpkgs,
      flake-parts,
      sops-nix,
      ...
    }:
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
                  # "timescaledb"
                  "pg_stat_statements"
                  "system_stats"
                ];
            };
          };
          commonPackages =
            [ ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.inotify-tools
            ];
          postgresqlWithPackages = pkgs.postgresql_18.withPackages (p: [
            p.pg_stat_statements
            p.system_stats
          ]);
        in
        {
          _module.args.pkgs = pkgs;

          process-compose."app-services" =
            { config, lib, ... }:
            let
              env = builtins.fromJSON (builtins.readFile ../.env-local.json);
              devDataDir = "./.data/pg";
            in
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services = {
                postgres."pg" = {
                  enable = true;
                  package = postgresqlWithPackages;
                  listen_addresses = env.PGHOST;
                  dataDir = devDataDir;

                  port = env.PGPORT;
                  settings = {
                     wal_level = "logical";
                  };
                  initialScript = {
                    before = ''
                      CREATE ROLE ${env.PGUSER} WITH LOGIN PASSWORD '${env.PGPASSWORD}' SUPERUSER;
                      CREATE DATABASE ${env.PGDATABASE};
                    '';
                    after = ''
                      psql -d ${env.PGDATABASE} -c 'CREATE EXTENSION IF NOT EXISTS pg_stat_statements;'
                      psql -d ${env.PGDATABASE} -c 'CREATE EXTENSION IF NOT EXISTS system_stats;'
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
