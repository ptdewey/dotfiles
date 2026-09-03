{ lib, ... }:
{
  dotfiles.agents.skills.finger_guns = import ../_lib.nix { inherit lib; } "finger-guns" ./.;
}
