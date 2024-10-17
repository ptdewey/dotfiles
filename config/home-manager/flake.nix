{
  description = "Home Manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Define outputs
  outputs = { nixpkgs, home-manager, self, ... }: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    overlay = final: prev: {
      blueprinter = import ./packages/blueprinter.nix { pkgs = prev; };
    };

    # Home directory configuration
    homeConfigurations = {
      "patrick" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = [ self.overlay ];
        };
        modules = [ ./home.nix ];
      };
    };

    packages.x86_64-linux.blueprinter = import ./packages/blueprinter.nix {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    };
  };
}
