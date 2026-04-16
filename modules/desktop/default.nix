{
  pkgs,
  dpkgs,
  lib,
  config,
  hostVars,
  ...
}:
{
  imports = [ ./steam.nix ];
  options.dlib.desktop.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the dlib desktop.
    '';
  };
  config = lib.mkIf config.dlib.desktop.enable {
    environment.persistence."/persist" = {
      directories = [
        "/var/lib/iwd"
        "/var/lib/bluetooth"
      ];
    };
    networking.wireless.iwd.enable = true;
    fonts = {
      packages = with pkgs; [
        gelasio
      ];
      fontconfig = {
        enable = true;
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
      };
    };
    environment.systemPackages =
      with pkgs;
      [
        vesktop
        dpkgs.helium
      ];
  };

}
