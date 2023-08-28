{
  description = "TSDZ2 motor firmware";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, self }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        binutils-stm8-gdb = pkgs.callPackage ./nix/stm8-binutils-gdb.nix { };
      in
      {
        defaultPackage = pkgs.callPackage ./nix/tsdz2-firmware.nix { inherit binutils-stm8-gdb; };
      }
    );
}
