{ lib, ... }:
{
  dotfiles.agents.skills.shared = import ../_lib.nix { inherit lib; } "shared" ./.;
}
