{
  pkgs,
  dpkgs,
  hostVars,
  ...
}:
{
  networking.networkmanager.enable = true;
  services.desktopManager.gnome = {
    enable = true;
  };
  services.displayManager.gdm = {
    enable = true;
  };
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
  fonts.fontconfig = {
    enable = true;
    allowBitmaps = true;
    useEmbeddedBitmaps = true;
  };
  environment.systemPackages = with pkgs; [
    vesktop
    fuzzel
    alacritty
    dpkgs.helium
  ];
}
