{
  description = "Patrick's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      europa = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/hosts/nixos/europa/home.nix ];
      };
      homeManagerApp = {
        type = "app";
        program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
      };
    in
    {
      homeModules.patrick = import ./nix/modules/patrick;

      homeConfigurations."patrick@europa" = europa;

      checks.${system}.europa-home = europa.activationPackage;

      apps.${system} = {
        default = homeManagerApp;
        home-manager = homeManagerApp;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          home-manager.packages.${system}.home-manager
          pkgs.nixfmt
          pkgs.shellcheck
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
