{
  pkgs,
  dpkgs,
  evalConfig,
}:
let
  inherit (pkgs) lib;
  #
  dlib = {
    mkDconf = import ./mkDconf.nix { inherit pkgs; };
  };
in
{
  inherit dlib;
}
// {
  mkHost = import ./mkHost.nix {
    inherit
      lib
      evalConfig
      dlib
      dpkgs
      ;
  };
}
