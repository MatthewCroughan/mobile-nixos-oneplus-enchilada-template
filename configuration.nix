{
  imports = [
    ./gnome-mobile
    ./minimal.nix
  ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  users.users = {
    root.password = "default";
    matthew = {
      isNormalUser = true;
      password = "default";
      extraGroups = [
        "dialout"
        "feedbackd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
}
