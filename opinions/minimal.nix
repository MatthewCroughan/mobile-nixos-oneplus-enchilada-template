{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/profiles/minimal.nix" ];
  environment.noXlibs = false; # Causes too many derivations to be overridden and therefore require compilation
}
