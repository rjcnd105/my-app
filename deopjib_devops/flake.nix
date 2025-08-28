{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
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
      unquote = s: builtins.replaceStrings [ "\"" ] [ "" ] s;
      env = builtins.fromJSON (builtins.readFile ./.env-dev.json);
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
        {

          _module.args.pkgs = pkgs;

          devShells.default = pkgs.mkShell {
            inputsFrom = [ self'.process-compose.devShell ];
            packages = with pkgs; [
              just
            ];
          };
        };
    };
}
