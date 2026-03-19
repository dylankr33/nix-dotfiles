{
  pkgs ? <nixpkgs>,
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nil
    nixd
    npins
    nixos-anywhere
    rust-analyzer
    nixfmt
  ];
}
