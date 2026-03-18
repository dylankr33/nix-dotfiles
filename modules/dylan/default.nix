{
  pkgs,
  dpkgs,
  lib,
  dlib,
  hostVars,
  ...
}:
{
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
    extraGroups = lib.flatten [
      "realtime"
      "audio"
      "wheel"
    ];
    hashedPassword = "$y$j9T$8.fMAkhjGqlgJCqZqAo721$fGUuH27Y4ugQqfITSfNeFoibwQ9U8KCc5yzopIugbvB";
  };
  hjem.users.dylan = {
    enable = true;
    packages = with pkgs; [ zed-editor ];
    xdg.config.files = {
      "zed/settings.json" = {
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
      "dconf/user".source = dlib.mkDconf {
        "org/gnome/desktop/interface" = {
          accent-color = "pink";
          color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "${dpkgs.dWalls}/share/wallpapers/osaka.jpg";
          picture-uri-dark = "${dpkgs.dWalls}/share/wallpapers/osaka.jpg";
        };
      };
    };
  };

}
