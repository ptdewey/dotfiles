{ config, pkgs, ... }:

{
    # Enable home-manager and channel version
    programs.home-manager.enable = true;
    home.stateVersion = "23.11";

    # Set username and home directory
    home.username = "patrick";
    home.homeDirectory = "/home/patrick";

    # gtk.enable = true;
    # gtk.cursorTheme.package = pkgs.bibata-cursors;
    # gtk.cursorTheme.name = "Bibata-Modern-Ice";
    #
    # gtk.theme.package = pkgs.adw-gtk3;
    # gtk.theme.name = "adw-gtk3";

    # Install nix packages into environment
    home.packages = with pkgs; [
        csvlens
        fd
        foliate
        fzf
        # lsd
        ripgrep
        tokei
        rustup

        neovim
        tree-sitter

        feh
        pywal

        stylua
        luajitPackages.luarocks
        go
        glow
        nodejs

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
    };
}
