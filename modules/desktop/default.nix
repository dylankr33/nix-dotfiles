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
      Enable the dlib gnome desktop.
    '';
  };
  config = lib.mkIf config.dlib.desktop.enable {
    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager"
        "/var/lib/bluetooth"
      ];
    };
    networking.networkmanager.enable = true;
    services.desktopManager.gnome = {
      enable = true;
    };
    services.displayManager.gdm = {
      enable = true;
    };
    environment.gnome.excludePackages = with pkgs; [
      baobab
      gnome-disk-utility
      geary
      seahorse
      sushi
      decibels
      epiphany
      gnome-text-editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      loupe
      papers
      gnome-connections
      showtime
      simple-scan
      snapshot
      yelp
    ];
    programs.dconf = {
      enable = true;
      profiles = {
        # A "user" profile with a database
        user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                text-scaling-factor = hostVars.scalingFactor;
              };
            };
          }
        ];
      };
    };
    fonts = {
      packages = with pkgs; [
        scientifica
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
      ]
      ++ (with pkgs.gnomeExtensions; [
        blur-my-shell
        dash-to-panel
      ]);
  };

}
