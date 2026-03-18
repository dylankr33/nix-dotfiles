{
  pkgs ? <nixpkgs>,
}:
let
  pname = "helium";
  version = "0.10.5.1";
  src = builtins.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-c/ea8C1XjTkBo0/ujGHEbKWyCmRMxyuiuOzAO9AMf1o=";
  };
  appImageContent = pkgs.appimageTools.extract { inherit pname version src; };
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps
    install -m 444 -D ${appImageContent}/${pname}.png -t $out/share/icons/hicolor/256x256/apps
    install -m 444 -D ${appImageContent}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
in
pkgs.appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    appImageContent
    extraInstallCommands
    ;
}
