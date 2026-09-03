{
  description = "Patrick's Home Manager configurations and agent tooling";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: import nixpkgs { inherit system; };

      # Build a standalone Home Manager configuration for one host.
      # Username and home directory are host facts, passed here per host —
      # never assumed inside nix/modules/patrick.
      mkHome =
        {
          system,
          username,
          homeDirectory,
          stateVersion,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          extraSpecialArgs = {
            inherit inputs username;
          };

          modules = [
            {
              programs.home-manager.enable = true;

              home = {
                inherit
                  homeDirectory
                  stateVersion
                  username
                  ;
              };
            }
          ]
          ++ modules;
        };
    in
    {
      # Reusable user modules. A NixOS or nix-darwin flake can import
      # homeModules.patrick into its own Home Manager setup later.
      homeModules = {
        patrick = import ./nix/modules/patrick;
        default = self.homeModules.patrick;
      };

      homeConfigurations."patrick@europa" = mkHome {
        system = "x86_64-linux";
        username = "patrick";
        homeDirectory = "/home/patrick";
        stateVersion = "24.05";
        modules = [ ./nix/hosts/nixos/europa/home.nix ];
      };

      checks.x86_64-linux = {
        europa-home = self.homeConfigurations."patrick@europa".activationPackage;

        # Full asset deployment: every skill and subagent across every
        # enabled client, so target collisions fail at build time.
        agents-module =
          (mkHome {
            system = "x86_64-linux";
            username = "patrick";
            homeDirectory = "/home/patrick";
            stateVersion = "24.05";
            modules = [
              ./nix/modules/patrick
              {
                dotfiles = {
                  enable = true;
                  agents = {
                    enable = true;
                    clients = {
                      claude.enable = true;
                      codex.enable = true;
                      pi.enable = true;
                      prime.enable = true;
                    };
                  };
                };
              }
            ];
          }).activationPackage;
      };

      apps = forAllSystems (
        system:
        let
          homeManager = home-manager.packages.${system}.home-manager;
        in
        {
          default = {
            type = "app";
            program = "${homeManager}/bin/home-manager";
          };
          home-manager = self.apps.${system}.default;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              home-manager.packages.${system}.home-manager
              pkgs.nixfmt-rfc-style
              pkgs.shellcheck
            ];
          };
        }
      );

      formatter = forAllSystems (system: (pkgsFor system).nixfmt-rfc-style);
    };
}
