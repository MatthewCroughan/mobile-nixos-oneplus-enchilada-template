{
  nixConfig = {
    extra-substituters = [ "https://matthewcroughan.cachix.org" ];
    extra-trusted-public-keys = [ "matthewcroughan.cachix.org-1:fON2C9BdzJlp1qPan4t5AF0xlnx8sB0ghZf8VDo7+e8=" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/a36fdb5";
    mobile-nixos = {
      url = "github:matthewcroughan/mobile-nixos/cb9041dbd26fae523a1451d11219874de55cbe98";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, mobile-nixos }@inputs:
  let
    commonModules = [
      (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
      ./configuration.nix
    ];
  in
  rec {
    images = {
#      oneplus-enchilada-cross-x86_64-linux = nixosConfigurations.oneplus-enchilada-cross-x86_64-linux.config.mobile.outputs.android.android-fastboot-images;
      oneplus-enchilada = nixosConfigurations.oneplus-enchilada.config.mobile.outputs.android.android-fastboot-images;
      binfmt-virtualbox-image =
        nixosConfigurations.binfmt-virtualbox-image.config.system.build.isoImage;
    };
    nixosConfigurations.binfmt-virtualbox-image = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        "${nixpkgs}/nixos/modules/virtualisation/virtualbox-image.nix"
        {
          virtualisation.virtualbox.guest.enable = nixpkgs.lib.mkForce true;
          boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        }
      ];
    };
#    nixosConfigurations.oneplus-enchilada-cross-x86_64-linux = nixpkgs.lib.nixosSystem {
#      system = "x86_64-linux";
#      modules = commonModules ++ [
#        {
#          nixpkgs.crossSystem = {
#            system = "aarch64-linux";
#          };
#        }
#      ];
#      specialArgs = { inherit inputs; };
#    };
    nixosConfigurations.oneplus-enchilada = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = commonModules;
      specialArgs = { inherit inputs; };
    };
  };
}
