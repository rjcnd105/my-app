{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/b599843bad24621dcaa5ab60dac98f9b0eb1cabe";
    flake-parts.url = "github:hercules-ci/flake-parts";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs =
     inputs@{
      self,
      nixpkgs,
      flake-parts,
      nix2container,
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
                  "timescaledb"
                ];
            };
          };
          commonPackages =
            [ ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.inotify-tools
            ];


          dockerDataDir = "/var/lib/postgresql/data";
          # --- 공통 Docker 이미지 설정 함수 ---
          buildDbImage = { pkgs, name, tag, user, password, dbName }:
          let
            postgresql = pkgs.postgresql_18;
          in
            pkgs.nix2container.buildImage {
              inherit name tag;
              copyToRoot = pkgs.buildEnv {
                name = "image-root";
                paths = [ postgresql ];
                pathsToLink = [ "/bin" ];
              };
              config = {
                Cmd = [ "${postgresql}/bin/postgres" "-D" dockerDataDir ];
                Volumes = { "${dockerDataDir}" = { }; };
                ExposedPorts = { "5432/tcp" = { }; };
                User = "postgres";
                # 환경 변수를 통해 DB 설정을 전달합니다. Dokploy에서 이 값들을 설정합니다.
                Env = [
                  "PGUSER=${user}"
                  "PGPASSWORD=${password}"
                  "PGDATABASE=${dbName}"
                ];
              };
            };
        in
        {
          _module.args.pkgs = pkgs;

          packages = {
            # 개발용 이미지: 이전과 동일
            dbImage-dev = buildDbImage {
              pkgs = pkgs;
              name = "deopjib-db-dev";
              tag = "latest";
              user = builtins.getEnv("POSTGRES_USER");
              password = builtins.getEnv("POSTGRES_PASSWORD");
              dbName = builtins.getEnv("POSTGRES_DB");
            };

            # 프로덕션용 이미지
            dbImage-prd = buildDbImage {
              pkgs = pkgs; # 안정적인 pkgs 사용
              name = "deopjib-db-prd";
              tag = "latest";
              user = builtins.getEnv("POSTGRES_USER");
              password = builtins.getEnv("POSTGRES_PASSWORD");
              dbName = builtins.getEnv("POSTGRES_DB");
            };
          };

          process-compose."app-services" =
            { config, lib, ... }:
            let
              env = builtins.fromJSON (builtins.readFile ../.env-dev.json);
              devDataDir = "./.data/pg";
            in
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services = {
                postgres."pg" = {
                  enable = true;
                  package = pkgs.postgresql_18;
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
