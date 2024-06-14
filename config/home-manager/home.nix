{ config, pkgs, ... }:

# let
#   nixgl = import <nixgl> { };
# in
{
    # Enable home-manager and channel version
    programs.home-manager.enable = true;
    home.stateVersion = "24.11";

    # Set username and home directory
    home.username = "patrick";
    home.homeDirectory = "/home/patrick";

    # gtk = {
    #     enable = true;
    #     theme.package = pkgs.adw-gtk3;
    #     theme.name = "adw-gtk3";
    # };

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
        # lsd

        ## neovim stuff
        neovim
        xclip
        tree-sitter

        ## shell stuff
        zsh

        ## languages and related utils
        gcc
        libgcc
        stylua
        luajitPackages.luarocks
        luajitPackages.jsregexp
        luajitPackages.lgi
        go
        glow
        nodejs
        rustup

        ## wallpaper and aesthetics utils
        feh
        pywal

        ## window manager config
        bspwm
        dunst
        polybar
        picom
        rofi
        sxhkd

        # nixgl.wezterm

        ## other gui applications
        # kitty
        # wezterm
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
