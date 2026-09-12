{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      commonModules = [
        ../../modules/common.nix
        ../../services/local-observability.nix
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
          ../../modules/gnome.nix
          ../../modules/niri.nix
          ../../modules/minecraft.nix
          ../../modules/steam.nix
          # ../../modules/lutris.nix
          ../../modules/discord.nix

          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ];
      };

      callisto = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./callisto/configuration.nix
          # ../../modules/gdm.nix
          ../../modules/tuigreet.nix
          ../../modules/niri.nix
          ../../modules/discord.nix
          ../../modules/river.nix

          {
            nixpkgs.overlays = [ ];
            nixpkgs.hostPlatform = "x86_64-linux";
          }
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
