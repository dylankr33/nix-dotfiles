{
  sprinkles ? (import ./npins).sprinkles,
  ...
}@overrides:
(import sprinkles).new {
  inherit overrides;
  sources = (import ./npins) // {
    users = ./users;
    dlib = ./lib;
    dpkgs = ./pkgs;
  };
  inputs =
    {
      sources,
      inputs,
      ...
    }:
    {
      pkgs = import sources.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      nixpkgs = sources.nixpkgs;
      modulesPath = sources.nixpkgs;
      undetected.nixosModules.default = "${sources.nixpkgs}/nixos/modules/installer/scan/not-detected.nix";
      disko.nixosModules.default = import "${sources.disko}/module.nix";
      impermanence.nixosModules.default = import "${sources.impermanence}/nixos.nix";
      hjem.nixosModules = import "${sources.hjem}/modules/nixos";

      dpkgs = import sources.dpkgs { inherit (inputs) pkgs; };
      dlib = (import sources.dlib) {
        inherit (inputs) pkgs dpkgs nixpkgs;
      };
    };
  outputs =
    { inputs, ... }:
    let
      inherit (inputs) dlib;
    in
    {
      nixosConfigurations =
        let
          modules = with inputs; [
            undetected.nixosModules.default
            disko.nixosModules.default
            impermanence.nixosModules.default
            hjem.nixosModules.default
            {
              dlib = {
                desktop.enable = true;
                users = [ "dylan" ];
              };
            }
          ];
          modulesPath = ./modules;
        in
        {
          omnibook = dlib.mkHost {
            inherit modules modulesPath;
            hostname = "omnibook";
            scalingFactor = 1.25;
          };
        };
    };
}
