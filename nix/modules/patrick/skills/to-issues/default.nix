{ lib, ... }:
{
  dotfiles.agents.skills.to_issues = import ../_lib.nix { inherit lib; } "to-issues" ./.;
}
