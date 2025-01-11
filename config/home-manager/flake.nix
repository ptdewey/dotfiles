{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # ags.url = "github:aylur/ags";
  };

  # Define outputs
  outputs = { home-manager, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in {
      # defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

      # Home directory configuration
      homeConfigurations = {
        "patrick" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };

          extraSpecialArgs = { inherit inputs; };

          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ./home.nix
          ];
        };
      };
    };
}
