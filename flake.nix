# tool configuration ^-^
# didnt want to recreate mason.nvim, this works well enuff
# `nix profile install .` to install!

{
  description = "kak tools!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      packages = {
        default = self.packages.${system}.stdPkgs;
        stdPkgs = pkgs.buildEnv {
          name = "tools";
          paths = with pkgs; [
            nodePackages_latest.typescript-language-server
            eslint_d
            prettierd
          ];
        };
      };
    }
  );
}
