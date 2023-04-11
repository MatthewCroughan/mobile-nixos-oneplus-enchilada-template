{
  nixConfig = {
    extra-substituters = [ "https://matthewcroughan.cachix.org" ];
    extra-trusted-public-keys = [ "matthewcroughan.cachix.org-1:fON2C9BdzJlp1qPan4t5AF0xlnx8sB0ghZf8VDo7+e8=" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    mobile-nixos = {
      url = "github:matthewcroughan/mobile-nixos";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, mobile-nixos }:
  let
    commonModules = [
      (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
      ./configuration.nix
    ];
  in
  {
    nixosConfigurations.oneplus-enchilada-cross-x86_64-linux = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [
        {
          nixpkgs.crossSystem = {
            system = "aarch64-linux";
          };
        }
      ];
    };
    nixosConfigurations.oneplus-enchilada = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = commonModules;
    };
  };
}
