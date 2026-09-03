{ lib, ... }:
{
  dotfiles.agents.skills.architect = import ../_lib.nix { inherit lib; } "architect" ./.;
}
