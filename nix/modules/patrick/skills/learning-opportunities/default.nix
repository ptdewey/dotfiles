{ lib, ... }:
{
  dotfiles.agents.skills.learning_opportunities = import ../_lib.nix {
    inherit lib;
  } "learning-opportunities" ./.;
}
