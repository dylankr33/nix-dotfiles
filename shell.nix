{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs,
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    nil
    nixd
    npins
    nixos-anywhere
    rust-analyzer
    nixfmt
  ];
}
