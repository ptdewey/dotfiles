_: {
  flake.homeModules.patrick =
    { lib, ... }:
    import ../_lib.nix { inherit lib; } "jj-workflow" ./.;
}
