{ lib, ... }:
{
  dotfiles.agents.skills.grill_with_docs = import ../_lib.nix { inherit lib; } "grill-with-docs" ./.;
}
