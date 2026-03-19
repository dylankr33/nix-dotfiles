{
  pkgs,
  dpkgs,
  lib,
  config,
  hostVars,
  ...
}:
{
  options.dlib.desktop.steam = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the dlib gnome desktop.
    '';
  };

  config =
    let
      dl = config.dlib.desktop;
    in
    (lib.mkIf (dl.enable && dl.steam)) {
      programs.steam = {
        enable = true;
      };
    };
}
