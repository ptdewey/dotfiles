{ lib, ... }:
{
  dotfiles.agents.skills.code_review = import ../_lib.nix { inherit lib; } "code-review" ./.;
}
