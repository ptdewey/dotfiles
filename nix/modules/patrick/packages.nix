_: {
  flake.homeModules.patrick =
    { lib, pkgs, ... }:
    {
      programs.home-manager.enable = true;

      home.packages =
        with pkgs;
        (
          [
            nix-prefetch-git
            csvlens
            fd
            fx
            fzf
            ripgrep
            tokei
            shellcheck-minimal
            jq
            pandoc
            fastfetch
            htop
            tmux
            lsd
            plantuml
            vhs
            oh-my-posh
            neovim
            typst
            tree-sitter
            stylua
            luajitPackages.jsregexp
            luajitPackages.luacheck
            go
            glow
            prettierd
            openssl
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            brightnessctl
            xclip
            feh
            foliate
            zathura
          ]
        );

      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };
}
