# Flake for Nix Home-Manager
{
    description = "Home Manager flake";

    # Define input sources
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager.url = "github:nix-community/home-manager";
        nixgl.url = "github:nix-community/nixGL";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    # Define outputs
    outputs = { nixpkgs, home-manager, nixgl, ... }: {
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

        # Home directory configuration
        homeConfigurations = {
            "patrick" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
                modules = [ ./home.nix ];
            };
        };
    };
}
