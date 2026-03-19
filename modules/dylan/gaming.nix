{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf (builtins.elem "gaming" config.dlib.dylan.features) {
  hjem.users.dylan = {
    packages = with pkgs; [
      prismlauncher
    ];
  };
}
