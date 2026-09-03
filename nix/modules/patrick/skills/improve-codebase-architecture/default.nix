{ lib, ... }:
{
  dotfiles.agents.skills.improve_codebase_architecture = import ../_lib.nix {
    inherit lib;
  } "improve-codebase-architecture" ./.;
}
