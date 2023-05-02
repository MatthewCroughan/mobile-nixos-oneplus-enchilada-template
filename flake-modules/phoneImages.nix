{ self, ... }:
{
  flake = { ... }: {
    # We only ever want to build for arm64, even when the host is x86_64-linux
    packages.x86_64-linux = self.packages.aarch64-linux;
  };
  perSystem = { pkgs, ... }: {
    packages = let
      mkImages = list:
        pkgs.lib.genAttrs
          (map (s: "${s}-images") list)
          (n: self.nixosConfigurations.${pkgs.lib.removeSuffix "-images" n}.config.mobile.outputs.android.android-fastboot-images);
    in mkImages [ "oneplus-enchilada" "oneplus-fajita" ];
  };
}
