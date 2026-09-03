{ lib }:
skill: dir:
lib.cleanSourceWith {
  name = "skill-${skill}";
  src = dir;
  filter = path: _type: builtins.baseNameOf path != "default.nix";
}
