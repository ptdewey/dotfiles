{ config, pkgs, ... }:

{
    # Enable home-manager and channel version
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";

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

        ## neovim stuff
        neovim
        xclip
        tree-sitter

        ## shell stuff
        zsh

        ## languages and related utils
        # gcc
        # libgcc
        stylua
        # luaPackages.luarocks
        # luaPackages.jsregexp
        # lua52Packages.lgi
        # luajit
        # luajitPackages.luarocks
        luajitPackages.jsregexp
        luajitPackages.luacheck
        # luajitPackages.lgi
        go
        glow
        nodejs
        nodePackages.prettier
        prettierd
        openssl
        rustup

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
        cbatticon
        cinnamon.nemo
        blueman
        xdg-user-dirs
        xsettingsd
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
