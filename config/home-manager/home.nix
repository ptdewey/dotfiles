{ config, pkgs, ... }:

{
    # Enable home-manager and channel version
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";

    # Set username and home directory
    home.username = "patrick";
    home.homeDirectory = "/home/patrick";

    programs = {
        direnv = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
        };
    };

    # Install nix packages into environment
    home.packages = with pkgs; [
        ## nix extras
        nix-prefetch-git

        ## misc command line utils
        csvlens
        fd
        foliate
        fx
        fzf
        ripgrep
        tokei
        shellcheck-minimal
        jq
        pandoc
        neofetch
        htop
        tmux
        lsd
        plantuml
        zathura

        ## neovim stuff
        neovim
        xclip
        tree-sitter

        ## shell stuff
        # zsh

        ## languages and related utils
        stylua
        luajitPackages.jsregexp
        luajitPackages.luacheck
        go
        glow
        nodejs
        prettierd
        openssl
        rustup
        quarto
        python312Packages.jupytext

        ## wallpaper and aesthetics utils
        feh
        pywal

        ## window manager config
        # awesome
        bspwm
        dunst
        polybar
        picom
        # rofi
        sxhkd

        ## other gui applications
        # discord
        # spotify

        ## awesomewm stuff
        roboto
        maim
        brightnessctl
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-lgc-plus
        noto-fonts-color-emoji
        papirus-icon-theme
        # cbatticon
        # cinnamon.nemo
        # blueman
        # xdg-user-dirs
        # xsettingsd

        tidal-hifi
    ];

    # Manage dotfiles
    home.file = {
        # TODO: figure out correct location for fonts on different systems
        # ".fonts".source = ~/dotfiles/fonts;
        # ".local/share/fonts".source = ~/dotfiles/fonts;
    };

    # Manage environment variables
    home.sessionVariables = {
        EDITOR = "nvim";
    };
}
