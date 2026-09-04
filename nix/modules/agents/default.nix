_: {
  flake.homeModules.patrick =
    { lib, ... }:
    let
      subagents = {
        builder = ./builder.md;
        explorer = ./explorer.md;
        researcher = ./researcher.md;
        worker = ./worker.md;
      };

      subagentDirectories = [
        ".claude/agents"
        ".codex/agents"
        ".pi/agent/agents"
      ];

      mappings = lib.concatLists (
        lib.mapAttrsToList (
          name: source:
          map (directory: {
            name = "${directory}/${name}.md";
            value = { inherit source; };
          }) subagentDirectories
        ) subagents
      );
    in
    {
      home.file = lib.listToAttrs mappings;
    };
}
