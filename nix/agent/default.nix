_: {
  flake.homeModules.patrick = {
    home.file = {
      ".agents/AGENTS.md".source = ./AGENTS.md;
      ".codex/AGENTS.md".source = ./AGENTS.md;
    };
  };
}
