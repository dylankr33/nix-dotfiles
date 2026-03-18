{
  pkgs ? <nixpkgs>,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "dWalls";
  version = "1";
  src = ../assets;
  buildPhase = ''
    mkdir -p $out/share
    cp -r $src $out/share/wallpapers
  '';
}
