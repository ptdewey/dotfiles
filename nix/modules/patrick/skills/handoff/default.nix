{ lib, ... }:
{
  dotfiles.agents.skills.handoff = import ../_lib.nix { inherit lib; } "handoff" ./.;
}
