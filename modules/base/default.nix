{
  modulesPath,
  pkgs,
  hostVars,
  dlib,
  ...
}:
{
  networking.hostName = hostVars.hostname;
  hjem.clobberByDefault = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      user.name = "dylank";
      user.email = "dylank@posteo.com";
      credential."https://codeberg.org".username = "dylank";
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
  };

  programs.bash.promptInit = ''
    PS1=' \w λ '
  '';

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings.experimental-features = "nix-command flakes";
    registry.nixpkgs.to = {
      type = "path";
      path = dlib.nixpkgsPath;
    };
    channel.enable = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

}
