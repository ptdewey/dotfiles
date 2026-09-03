{ lib, ... }:
{
  dotfiles.agents.skills.grill_me = import ../_lib.nix { inherit lib; } "grill-me" ./.;
}
