{
  imports = [
    ./gnome-mobile
    ./minimal.nix
    ./quirks.nix
    ./recommended.nix
  ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  users.users = {
    root.password = "default";
    defaultUser = {
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
