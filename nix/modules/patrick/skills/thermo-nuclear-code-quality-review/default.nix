{ lib, ... }:
{
  dotfiles.agents.skills.thermo_nuclear_code_quality_review = import ../_lib.nix {
    inherit lib;
  } "thermo-nuclear-code-quality-review" ./.;
}
