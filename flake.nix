{
  description = "PubChemRDF KG BioBrick";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    biobricks-script-lib = {
      url = "path:./vendor/biobricks-script-lib";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, biobricks-script-lib }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = mkShell {
          buildInputs = [
            apache-jena
            librdf
            wget
            perlPackages.TextCSV
            moreutils
            pigz
          ] ++ biobricks-script-lib.packages.${system}.buildInputs;

          env = {
            JENA_HOME = "${apache-jena}";
          };

          shellHook = ''
            # Activate biobricks-script-lib environment
            eval $(${biobricks-script-lib.packages.${system}.activateScript})
          '';
        };
      });
}
