{ self, ... }:
{
  perSystem = { pkgs, ... }: {
    packages = let
      mkImages = list:
        pkgs.lib.genAttrs
          (map (s: "${s}-images") list)
          (n: self.nixosConfigurations.${pkgs.lib.removeSuffix "-images" n}.config.mobile.outputs.android.android-fastboot-images);
    in mkImages [ "oneplus-enchilada" "oneplus-fajita" ];
  };
}
