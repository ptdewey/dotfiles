{ lib, ... }:
{
  dotfiles.agents.skills.jj_workflow = import ../_lib.nix { inherit lib; } "jj-workflow" ./.;
}
