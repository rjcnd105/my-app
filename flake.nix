{


  inputs.nixpkgs.url = "github:nixos/nixpkgs/b599843bad24621dcaa5ab60dac98f9b0eb1cabe";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";


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
          editor = builtins.getEnv "EDITOR";
          visual = builtins.getEnv "VISUAL";
          ageKeyFile = builtins.getEnv "SOPS_AGE_KEY_FILE";
          commonPackages =  [ ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            pkgs.inotify-tools
          ];
          envPackages = [
            pkgs.sops
            pkgs.age
            pkgs.ssh-to-age
          ] ++ commonPackages;
        in
        {
           packages = {
            # 여기에 flake가 외부로 노출할 패키지들을 정의합니다.
            sops = pkgs.sops;
            age = pkgs.age;
            ssh-to-age = pkgs.ssh-to-age;
          };
          devShells = {
            default = pkgs.mkShellNoCC {
              packages = envPackages;
              commands = [

              ];
              shellHook = ''
                export EDITOR=${lib.escapeShellArg editor}
                export VISUAL=${lib.escapeShellArg visual}
                export AGE_KEY_FILE=${lib.escapeShellArg ageKeyFile}
              '';
            };
          };
        };
    };
}
