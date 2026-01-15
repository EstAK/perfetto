{
  description = "Perfetto flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs, ... }:

    let 
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in {

      packages = eachSystem (system : 
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          perfetto = pkgs.callPackage ./default.nix {}; # handle cross-compilation later on
          default = self.packages.${system}.perfetto;
        });

      devShells = eachSystem ( system :
        let
          pkgs = import nixpkgs { inherit system; };
          # Define the raw store path
        in {
          default = pkgs.mkShell {
            inputsFrom = [
              self.packages.${system}.perfetto
            ];
          };
        });
    };
}
