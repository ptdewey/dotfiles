{ lib, ... }:
{
  dotfiles.agents.skills.to_prd = import ../_lib.nix { inherit lib; } "to-prd" ./.;
}
