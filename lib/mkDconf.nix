{
  pkgs ? <nixpkgs>,
}:
settings:
let
  inherit (pkgs) lib;
  settings_str = lib.generators.toDconfINI settings;
  settings_file = pkgs.writeText "conf.ini" settings_str;
in
pkgs.runCommand "db" { nativeBuildInputs = [ pkgs.dconf ]; } ''
  mkdir -p ./include
  cp ${settings_file} ./include/settings
  dconf compile $out ./include
''
