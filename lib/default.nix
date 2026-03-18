{
  pkgs,
  dpkgs,
  nixpkgs,
}:
let
  inherit (pkgs) lib;
  evalConfig = import "${nixpkgs}/nixos/lib/eval-config.nix";
  dlib = {
    mkDconf = import ./mkDconf.nix { inherit pkgs; };
    nixpkgsPath = nixpkgs;
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
