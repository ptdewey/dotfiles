{
  config,
  lib,
  pkgs,
  ...
}:

let
  rocmEnv = pkgs.symlinkJoin {
    name = "rocm-env";
    paths = with pkgs.rocmPackages; [
      hipcc
      rocminfo
      rocm-smi
      rocm-runtime
      clr
      hipblas
      hipblas-common
      hipblaslt
      rocblas
      rocwmma
      hipcub
      rocprim
      rocm-toolchain
      rocm-device-libs
      rocm-comgr
    ];
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      # Allocate 96GB for VRAM, maybe bump to 108GB
      # GTT sizen MiB = GiB * 1024, TTM pages_limt = GiB * 262144
      # "amdgpu.gttsize=98304"
      # "ttm.pages_limit=25165824" # use "28311552" for 108
      "amdgpu.gttsize=126976"
      "ttm.pages_limit=32505856"
      "ttm.page_pool_size=32505856"
      "amd_iommu=off"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  networking.hostName = "calypso"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "render"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    gcc
    go
    nodejs
    firefox
    pi-coding-agent
    codex
    nvtopPackages.amd
    xclip
    tokei
    git
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
    fastfetch
    gnumake
    csvlens
    jq
    fx
    websocat
    zip
    ast-grep
    just
    luaPackages.fennel
    atproto-goat
    rtk
    python3
    jujutsu
    vulkan-tools
    clinfo
    llama-cpp-vulkan
    python313Packages.huggingface-hub
    llmfit
    fzf
    btop
    nil
    sops
    gleam
    beam28Packages.erlang
    beam28Packages.rebar
    beam28Packages.elixir
    pnpm
    templ

    # Load rocm packages
    rocmEnv
  ];

  sops.age = {
    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = "/var/lib/sops-nix/key.txt";
    generateKey = true;
  };

  # ROCM stuff
  environment.variables = {
    ROCM_PATH = "${rocmEnv}";
    HIP_PATH = "${rocmEnv}";
    # This is the important fix.
    HIP_CLANG_PATH = "${pkgs.rocmPackages.rocm-toolchain}/bin";

    # Avoid hipcc probing CUDA/nvcc.
    HIP_PLATFORM = "amd";
  };

  # Compatibility for projects that hardcode /opt/rocm.
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm - - - - ${rocmEnv}"
  ];

  # Add missing dynamic libs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ sqlite ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.patrick.shell = pkgs.zsh;

  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    4000
    5173
    8000
    8080
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
