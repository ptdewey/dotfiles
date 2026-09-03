{
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.agents;
  enabledClients = lib.filterAttrs (_: client: client.enable) cfg.clients;

  skillMappings = lib.concatLists (
    lib.mapAttrsToList (
      skillName: source:
      lib.mapAttrsToList (_: client: {
        name = "${client.skillDirectory}/${skillName}";
        value = { inherit source; };
      }) enabledClients
    ) cfg.skills
  );

  subagentMappings = lib.concatLists (
    lib.mapAttrsToList (
      subagentName: source:
      lib.concatLists (
        lib.mapAttrsToList (
          _: client:
          lib.optional (client.subagentsDirectory != null) {
            name = "${client.subagentsDirectory}/${subagentName}.md";
            value = { inherit source; };
          }
        ) enabledClients
      )
    ) cfg.subagents
  );

  allTargets = map (mapping: mapping.name) (skillMappings ++ subagentMappings);

  allDirectories =
    map (client: client.skillDirectory) (lib.attrValues enabledClients)
    ++ lib.filter (dir: dir != null) (
      map (client: client.subagentsDirectory) (lib.attrValues enabledClients)
    );
in
{
  options.dotfiles.agents = {
    enable = lib.mkEnableOption "client-neutral agent assets";

    skills = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Mapping from skill names to canonical skill payload directories.
        Each skill directory under `nix/modules/home/skills/` registers
        itself through its `default.nix`.
      '';
    };

    subagents = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Mapping from subagent names to their definition files. Subagents
        deploy only to clients whose subagentsDirectory is set.
      '';
    };

    clients = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "agent asset deployment for this client";

            skillDirectory = lib.mkOption {
              type = lib.types.str;
              description = "Home-relative directory where this client discovers skills.";
            };

            subagentsDirectory = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Home-relative directory where this client discovers subagent
                definitions, or null when the client does not support them.
              '';
            };
          };
        }
      );
      default = { };
      description = ''
        Coding-agent clients that receive canonical skills and subagent
        definitions.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Defaults use per-attribute mkDefault because wrapping the whole
    # attrset in mkDefault drops these definitions whenever any module
    # defines part of the same client submodule.
    dotfiles.agents.clients = {
      claude = {
        skillDirectory = lib.mkDefault ".claude/skills";
        subagentsDirectory = lib.mkDefault ".claude/agents";
      };
      codex = {
        skillDirectory = lib.mkDefault ".codex/skills";
        subagentsDirectory = lib.mkDefault ".codex/agents";
      };
      prime = {
        skillDirectory = lib.mkDefault ".prime/agent/skills";
      };
      pi = {
        skillDirectory = lib.mkDefault ".pi/agent/skills";
        subagentsDirectory = lib.mkDefault ".pi/agent/agents";
      };
    };

    assertions = [
      {
        assertion = lib.all (dir: !(lib.hasPrefix "/" dir)) allDirectories;
        message = "Agent client asset directories must be relative to the home directory";
      }
      {
        assertion = builtins.length allTargets == builtins.length (lib.unique allTargets);
        message = "Agent asset deployment produced duplicate home.file targets";
      }
    ];

    home.file = builtins.listToAttrs (skillMappings ++ subagentMappings);
  };
}
