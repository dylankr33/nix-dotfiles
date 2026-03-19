{
  pkgs,
  config,
  hostVars,
  lib,
  ...
}:
lib.mkIf (builtins.elem "dev" config.dlib.dylan.features) {
  hjem.users.dylan = {
    packages = with pkgs; [ zed-editor ];
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
    };
  };
}
