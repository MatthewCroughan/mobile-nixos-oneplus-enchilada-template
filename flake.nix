{
  nixConfig = {
    extra-substituters = [ "https://matthewcroughan.cachix.org" ];
    extra-trusted-public-keys = [ "matthewcroughan.cachix.org-1:fON2C9BdzJlp1qPan4t5AF0xlnx8sB0ghZf8VDo7+e8=" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    mobile-nixos = {
      url = "github:matthewcroughan/mobile-nixos/7a6e97e3af73c4cca87e12c83abcb4913dac7dbc";
      flake = false;
    };
    nixos-shell.url = "github:Mic92/nixos-shell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-software-center.url = "github:vlinkz/nix-software-center";
  };
  outputs = { self, nixpkgs, mobile-nixos, nix-software-center, nixos-shell, flake-parts }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake-modules/phoneImages.nix
        ./flake-modules/binfmt-sdk.nix
      ];
      systems = [
        "aarch64-linux"
      ];
      flake = { ... }: {
        nixosConfigurations = {
          oneplus-fajita = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
              ./opinions/configuration.nix
            ];
            specialArgs = { inherit inputs; };
          };
          oneplus-enchilada = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
              ./opinions/configuration.nix
            ];
            specialArgs = { inherit inputs; };
          };
        };
      };
    };
}
