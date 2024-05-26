{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    openocd_src.url = "git+https://github.com/openocd-org/openocd.git?submodules=1";
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

            enableParallelBuilding = true;

            patches = [];

            patchPhase = ''
              sed -i "/git/d" bootstrap
              ./bootstrap
            '';

            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ (with pkgs; [
              autoconf
              automake
              libtool
              which
            ]);
          });
        };
      }
    );
}
