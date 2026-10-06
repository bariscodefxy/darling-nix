{ description = "Nixpkgs overlay for Darling";

  inputs.nixpkgs.url = github:nixos/nixpkgs;

  nixConfig.extra-substituters = "https://baris-darling.cachix.org";
  # Fill in from the cache page on cachix.org after creating it.
  nixConfig.extra-trusted-public-keys = "baris-darling.cachix.org-1:PLACEHOLDER";

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays/darling.nix)
        ];
      };
    in {
      legacyPackages = pkgs;

      packages = {
        "darling" = pkgs.darling;
      };

      checks = {
        "darling" = nixpkgs.lib.nixos.runTest ./tests/darling.nix;
      };
    });
}
