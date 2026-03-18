{
  lib ? <nixpkgs>.lib,
  evalConfig,
  dlib,
  dpkgs,
}:
{
  hostname,
  scalingFactor,
  modulesPath,
  modules,
}:
let
  specialArgs = {
    inherit dlib dpkgs;
    hostVars = {
      inherit hostname scalingFactor;
    };
  };
in
evalConfig {
  inherit specialArgs;
  system = "x86_64-linux";
  modules = lib.flatten [
    modules
    "${modulesPath}/hosts/${hostname}"
    "${modulesPath}/base"
    "${modulesPath}/desktop"
    "${modulesPath}/dylan"
  ];
}
