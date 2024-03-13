# Flake for Nix Home-Manager
{
    description = "Home Manager flake";

    # Define input sources
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    # Define outputs
    outputs = { nixpkgs, home-manager, ... }: {
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

        # Home directory configuration
        homeConfigurations = {
            "patrick" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [./home.nix];
            };
        };
    };
}
