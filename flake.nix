{
  description = "Patrick's multi-platform machine configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      imports = [
        (inputs.import-tree.matchNot ".*/assets/.*" ./nix/modules)
        home-manager.flakeModules.home-manager
      ];
      perSystem =
        { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          _module.args.pkgs = pkgs;
          devShells.default = pkgs.mkShell {
            packages = [
              home-manager.packages.${system}.home-manager
              pkgs.nixfmt
              pkgs.shellcheck
            ];
          };
          formatter = pkgs.nixfmt;
        };
    };
}
