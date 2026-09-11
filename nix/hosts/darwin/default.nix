{ inputs, ... }:
let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  flake.homeConfigurations."patrick.dewey" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [ ./eucalyptus/home.nix ];
  };
}
