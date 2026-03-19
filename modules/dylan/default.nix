{
  pkgs,
  dpkgs,
  lib,
  dlib,
  config,
  ...
}:
{
  imports = [
    ./dev.nix
  ];
  options = {
    dlib.dylan.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    dlib.dylan.features = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
  config = lib.mkIf config.dlib.dylan.enable {
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
    hjem.users.dylan = lib.mkMerge [
      {
        enable = true;
        packages = with pkgs; [
          bat
          tokei
        ];
      }
      (lib.mkIf config.dlib.desktop.enable {
        packages = with pkgs; [
          obsidian
          spotify
          gnomeExtensions.blur-my-shell
        ];
        xdg.config.files = {
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
                clock-format = "12h";
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
                enabled-extensions = with pkgs.gnomeExtensions; [
                  blur-my-shell.extensionUuid
                ];
              };
              "org/gnome/shell/app-switcher" = {
                current-workspace-only = true;
              };
            }
          );
        };
      })
    ];
  };
}
