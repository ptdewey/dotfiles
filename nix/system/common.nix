{ inputs, pkgs, ... }:

{
  # Common package list
  environment.systemPackages = with pkgs; [
    git
    tokei
    wget
    gcc
    curl
    go
    fzf
    ripgrep
    tree
    tmux
    unzip
    lm_sensors
    fd
    htop
    killall
    oh-my-posh
    lsd
    tree-sitter
    nodejs
    fastfetch
    python315
    gnumake
    csvlens
    jq
    lshw
    vlc
    gnupg
    feh
    zathura
    fx
    glow
    websocat
    pandoc
    inputs.zen-browser.packages."${system}".beta
    gimp
    gh
    alacritty
    zip
    ast-grep
    nmap
    # libreoffice
    yaru-theme
    bibata-cursors
    typst
    opencode
    caligula
    mpv
    mpd
    stylua
    luajitPackages.luacheck
    just
    go-mockery
    inotify-tools
    luajit
    luajitPackages.luarocks
    luajitPackages.jsregexp
    luaPackages.fennel
    fennel-ls
    fnlfmt
    cmake
    ninja
    jujutsu
    # nix-index
    ffmpeg
    rustc
    cargo
    rust-analyzer
    rustfmt
    lld
    nh
    feishin
    atproto-goat
    pnpm
    dig
    host
    thunderbird
    templ
    codex
    herdr
    bazecor
  ];

  # Add missing dynamic libs (do not include in environment.systemPackages)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ sqlite ];

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Use nightly if there are ever issues with stable
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.patrick.shell = pkgs.zsh;

  services.gvfs.enable = true;

  # Dictionary word list (used with nvim)
  environment.wordlist = {
    enable = true;
    lists = {
      WORDLIST = [ "${pkgs.scowl}/share/dict/words.txt" ];
    };
  };
}
