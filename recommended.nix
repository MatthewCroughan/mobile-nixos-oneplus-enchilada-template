{ pkgs, inputs, ...}:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    (builtins.getFlake "github:vlinkz/nix-software-center/8c66618ebb85263e58c4b1b5e46bc954d55a418b").packages.${pkgs.hostPlatform.system}.default
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
