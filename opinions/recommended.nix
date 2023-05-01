{ pkgs, lib, inputs, ...}:
{
  hardware.pulseaudio.enable = lib.mkDefault true;
  services.pipewire.enable = lib.mkDefault false;

  # When ram gets low, enabling zram helps
  zramSwap.enable = lib.mkDefault true;

  # Enable transparent x86 emulation of all kinds
  boot.binfmt.emulatedSystems = lib.mkDefault [ "x86_64-linux" "i686-linux" "i386-linux" "i486-linux" "i586-linux" ];

  environment.systemPackages = with pkgs; [
    vim
    git
    firefox
    inputs.nix-software-center.packages.${pkgs.hostPlatform.system}.default
  ];

  nix = {
    settings = {
      trusted-users = [ "@wheel" "root" "nix-ssh" ];
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
}
