{
  pkgs,
  dpkgs,
  lib,
  config,
  dlib,
  ...
}:
{
  imports = [
    ./dev.nix
    ./gaming.nix
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
      shell = pkgs.fish;
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
        xdg.config.files = {
          "fish/config.fish".source = ./misc/config.fish;
        };
      }
      (lib.mkIf config.dlib.desktop.enable {

        packages = with pkgs; [
          obsidian
        ];
        xdg.config.files = {
          "dconf/user".source = dlib.mkDconf {
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
              disable-user-extensions = false;
              favorite-apps = [
                "helium.desktop"
                "Zed.desktop"
                "org.gnome.Nautilus.desktop"
                "org.gnome.Console.desktop"
              ];
              enabled-extensions = (
                builtins.map (f: f.extensionUuid) (
                  with pkgs.gnomeExtensions;
                  [
                    blur-my-shell
                  ]
                )
              );
            };
            "org/gnome/shell/extensions/dash-to-panel" = {
              appicon-padding = lib.gvariant.mkUint32 8;
              trans-use-dynamic-opacity = true;
              trans-panel-opacity = lib.gvariant.mkDouble 40.0;
              panel-sizes = ''{"0":72}'';
            };
            "org/gnome/shell/app-switcher" = {
              current-workspace-only = true;
            };
          };
        };
      })
    ];
  };
}
