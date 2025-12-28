{
  description = "Perfetto flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (system : 
      let 
        pkgs = import nixpkgs { inherit system; };
        fhs = pkgs.buildFHSEnv {
          name = "fhs-shell";
          targetPkgs = pkgs: with pkgs; [
            glibc
            glibc.dev
            gcc.cc
            python3
            ninja
            gn
            libz

            stdenv
            llvmPackages_19.clang
            llvmPackages_19.libcxx
            llvmPackages_19.libunwind
          ];
        };

        packages.perfetto = pkgs.callPackage ./default.nix {};
      in {

        packages.default = packages.perfetto;
        devShells.default = fhs.env;
        # devShells.default = pkgs.mkShell {
        #   packages = with pkgs; [
        #     # gcc

        #   ];
        #   # C_INCLUDE_PATH="${pkgs.libbpf}/include:${pkgs.linuxHeaders}/include:$C_INCLUDE_PATH";
        # };
      }
    );
}
