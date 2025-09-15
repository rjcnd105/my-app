{

  inputs.nixpkgs.url = "github:nixos/nixpkgs/b599843bad24621dcaa5ab60dac98f9b0eb1cabe";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  flake-parts.url = "github:hercules-ci/flake-parts";


  outputs = inputs@{
      self,
      nixpkgs,
      flake-parts,
      sops-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs self;  } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      debug = true;
      perSystem = {
        system,
        lib,
        config,
        ...
      }: let
          pkgs = import nixpkgs {
            system = system;
          };
          commonPackages =  [ ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            pkgs.inotify-tools
          ];
        in
        {
          devShells = {
            env = pkgs.mkShellNoCC {
              packages = [
                pkgs.ssh-to-age
              ] ++ commonPackages;

              shellHook = ''
                eval "$(mise activate bash)"
              '';
            };
          };
        };
    };
}
