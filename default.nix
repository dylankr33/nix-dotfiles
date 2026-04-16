{
  sprinkles ? (import ./npins).sprinkles,
  ...
}@overrides:
(import sprinkles).new {
  inherit overrides;
  sources = (import ./npins) // {
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
      packages.x86_64-linux = { inherit (inputs.dpkgs) helium dWalls; };
      devShells.x86_64-linux.default = import ./shell.nix { inherit (inputs) pkgs; };
      nixosConfigurations =
        let
          config.dylan = {
            enable = true;
            features = [
              "gaming"
            ];
          };
          modules = with inputs; [
            undetected.nixosModules.default
            disko.nixosModules.default
            impermanence.nixosModules.default
            hjem.nixosModules.default
          ];
          modulesPath = ./modules;
        in
        {
          omnibook = dlib.mkHost {
            inherit modulesPath;
            modules = modules ++ [
              {
                dlib = {
                  desktop = {
                    enable = true;
                    steam = true;
                  };
                  inherit (config) dylan;
                };
              }
            ];
            hostname = "omnibook";
            scalingFactor = 1.25;
          };
        };
    };
}
