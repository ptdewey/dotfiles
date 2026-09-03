{ lib, ... }:
{
  dotfiles.agents.skills.tdd = import ../_lib.nix { inherit lib; } "tdd" ./.;
}
