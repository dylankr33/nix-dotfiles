{
  pkgs,
  dpkgs,
  lib,
  dlib,
  hostVars,
  config,
  options,
  ...
}:
{
  options.dlib.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      List of users.
    '';
  };
  config = lib.mkIf (builtins.elem "dylan" config.dlib.users) {
    environment.persistence."/persist".users.dylan = {
      directories = [
        "Desktop"
        "Pictures"
        "Videos"
        "Documents"
        "Music"
        "Templates"
        "Downloads"
        ".ssh"
        ".config"
        ".local"
        ".cache"
      ];
    };
    users.users.dylan = {
      isNormalUser = true;
      extraGroups = [
        "realtime"
        "audio"
        "wheel"
      ];
      hashedPassword = "$y$j9T$8.fMAkhjGqlgJCqZqAo721$fGUuH27Y4ugQqfITSfNeFoibwQ9U8KCc5yzopIugbvB";
    };
    hjem.users.dylan = {
      enable = true;
      packages =
        with pkgs;
        lib.mkIf config.dlib.desktop.enable [
          zed-editor
          gnomeExtensions.blur-my-shell
        ];
      xdg.config.files = {
        "zed/settings.json" = lib.mkIf config.dlib.desktop.enable {
          generator = lib.generators.toJSON { };
          value = {
            disable_ai = true;
            auto_install_extensions = {
              github-dark-default = true;
              nix = true;
            };
            theme = {
              mode = "system";
              light = "Ayu Light";
              dark = "GitHub Dark Default";
            };
            buffer_font_size = hostVars.scalingFactor * 14;
            ui_font_size = hostVars.scalingFactor * 16;
          };
        };
        "dconf/user".source = lib.mkIf config.dlib.desktop.enable (
          dlib.mkDconf {
            "org/gnome/desktop/input-sources" = {
              xkb-options = [
                "compose:ralt"
                "caps:ctrl_modifier"
              ];
            };
            "org/gnome/desktop/interface" = {
              accent-color = "pink";
              color-scheme = "prefer-dark";
            };
            "org/gnome/desktop/background" = {
              picture-uri = "${dpkgs.dWalls}/share/wallpapers/osaka.jpg";
              picture-uri-dark = "${dpkgs.dWalls}/share/wallpapers/osaka.jpg";
            };
            "org/gnome/shell" = {
              favorite-apps = [
                "helium.desktop"
                "Zed.desktop"
                "org.gnome.Nautilus.desktop"
                "org.gnome.Console.desktop"
              ];
              enabled-extensions = [
                pkgs.gnomeExtensions.blur-my-shell.extensionUuid
              ];
            };
            "org/gnome/shell/app-switcher" = {
              current-workspace-only = true;
            };
          }
        );
      };
    };
  };

}
