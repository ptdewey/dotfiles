{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      commonModules = [
        ../../system/common.nix
        ../../system/services/local-observability.nix
        {
          # Keep the flake's nixpkgs available through the registry and NIX_PATH.
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
          nix.settings.nix-path = inputs.nixpkgs.lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
        }
      ];
    in
    {
      europa = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./europa/configuration.nix
          ./europa/home.nix
          ../../system/desktops/gnome.nix
          ../../system/desktops/niri.nix
          ../../system/games/minecraft.nix
          ../../system/games/steam.nix
          # ../../system/games/lutris.nix
          ../../system/apps/discord.nix

          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ];
      };

      callisto = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./callisto/configuration.nix
          # ../../system/desktops/gdm.nix
          ../../system/desktops/tuigreet.nix
          ../../system/desktops/niri.nix
          ../../system/apps/discord.nix
          ../../system/desktops/river.nix

          {
            nixpkgs.overlays = [ ];
            nixpkgs.hostPlatform = "x86_64-linux";
          }
        ];
      };

      luna = inputs.nixpkgs-stable.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          nixpkgs = inputs.nixpkgs-stable;
        };
        modules = [
          # Don't include common modules on Luna.
          ./luna/configuration.nix
          ../../system/utilities/jellyfin.nix
          ../../system/utilities/forgejo.nix

          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ];
      };

      calypso = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./calypso/configuration.nix
          inputs.sops-nix.nixosModules.sops

          {
            nixpkgs.overlays = [ ];
            nixpkgs.hostPlatform = "x86_64-linux";
          }
        ];
      };
    };
}
