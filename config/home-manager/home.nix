{ config, pkgs, ... }:

{
    # Enable home-manager and channel version
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";

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
        # lsd

        ## neovim stuff
        neovim
        tree-sitter

        ## wallpaper and aesthetics utils
        feh
        pywal
        # libadwaita
        # adwaita-qt

        ## languages and related utils
        stylua
        luajitPackages.luarocks
        luajitPackages.jsregexp
        luajitPackages.lgi
        go
        glow
        nodejs
        rustup

        ## window manager config
        # bspwm
        # dunst
        # polybar
        # picom
        # rofi
        # sxhkd
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
        # QT_STYLE_OVERRIDE = "adwaita-dark";
    };
}
