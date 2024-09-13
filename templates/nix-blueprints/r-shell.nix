{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs-unstable";
  };
  outputs = { nixpkgs, ... }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems(pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          R
          (with pkgs.rPackages; [
              data_table
              dplyr
              ggplot2
              jsonlite
              tidyverse
              wesanderson
            ]
          )
        ];
      };
    });
  };
}
