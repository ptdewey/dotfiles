{ lib, ... }:
{
  dotfiles.agents.skills.skill_deslop = import ../_lib.nix { inherit lib; } "skill-deslop" ./.;
}
