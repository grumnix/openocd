{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    openocd_src.url = "github:openocd-org/openocd";
    openocd_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, openocd_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = openocd;

          openocd = pkgs.openocd.overrideAttrs (oldAttrs: {
            src = openocd_src;
          });
        };
      }
    );
}
