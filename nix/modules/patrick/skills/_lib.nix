{ lib }:
skill: dir:
let
  source = lib.cleanSourceWith {
    name = "skill-${skill}";
    src = dir;
    filter = path: _type: builtins.baseNameOf path != "default.nix";
  };

  skillDirectories = [
    ".claude/skills"
    ".codex/skills"
    ".prime/agent/skills"
    ".pi/agent/skills"
  ];
in
{
  home.file = lib.listToAttrs (
    map (directory: {
      name = "${directory}/${skill}";
      value = { inherit source; };
    }) skillDirectories
  );
}
