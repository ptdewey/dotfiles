{ lib, ... }:
{
  dotfiles.agents.skills.go_idioms = import ../_lib.nix { inherit lib; } "go-idioms" ./.;
}
