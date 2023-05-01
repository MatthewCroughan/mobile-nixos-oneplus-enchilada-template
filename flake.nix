{
  nixConfig = {
    extra-substituters = [ "https://matthewcroughan.cachix.org" ];
    extra-trusted-public-keys = [ "matthewcroughan.cachix.org-1:fON2C9BdzJlp1qPan4t5AF0xlnx8sB0ghZf8VDo7+e8=" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mobile-nixos = {
      url = "github:matthewcroughan/mobile-nixos/7a6e97e3af73c4cca87e12c83abcb4913dac7dbc";
      flake = false;
    };
    nixos-shell.url = "github:Mic92/nixos-shell";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = { self, nixpkgs, mobile-nixos, nixos-shell, flake-parts }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./phoneImages.nix
      ];
      systems = [
        "aarch64-linux"
      ];
      flake = { ... }: {
        apps.x86_64-linux.binfmt-sdk-nixos-shell = {
          type = "app";
          program = builtins.toPath (nixpkgs.legacyPackages.x86_64-linux.writeShellScript "run-binfmt-sdk-nixos-shell" ''
            rm nixos.qcow2 || true
            export NIX_CONFIG="experimental-features = nix-command flakes"
            export PATH=$PATH:${nixpkgs.legacyPackages.x86_64-linux.nixUnstable}/bin
            ${nixos-shell.packages.x86_64-linux.nixos-shell}/bin/nixos-shell --flake ${self}#binfmt-sdk-nixos-shell
          '');
        };
        nixosConfigurations = {
          oneplus-fajita = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
              ./configuration.nix
            ];
            specialArgs = { inherit inputs; };
          };
          oneplus-enchilada = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
              ./configuration.nix
            ];
            specialArgs = { inherit inputs; };
          };
          binfmt-sdk-nixos-shell = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              nixos-shell.nixosModules.nixos-shell
              ({ pkgs, ... }: {
                virtualisation = {
                  memorySize = 8192;
                  cores = 4;
                  diskSize = 80 * 1024;
                  writableStoreUseTmpfs = false;
                };
                nixos-shell.mounts.mountHome = false;
                boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
                boot.kernelPackages = pkgs.linuxPackages_latest;
                environment.systemPackages = with pkgs; [
                  vim
                  git
                  btop
                ];
                services.mingetty.autologinUser = "root";
                nix = {
                  settings = {
                    trusted-users = [ "@wheel" "root" ];
                    auto-optimise-store = true;
                  };
                  package = pkgs.nixUnstable;
                  extraOptions =
                    let empty_registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}''; in
                    ''
                      experimental-features = nix-command flakes
                      flake-registry = ${empty_registry}
                      builders-use-substitutes = true
                    '';
                  registry.nixpkgs.flake = inputs.nixpkgs;
                  nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
                };
              })
            ];
          };
        };
      };
    };
}
