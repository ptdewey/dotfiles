{
  config,
  pkgs,
  inputs,
  ...
}:

let
  unstablePkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [ "zpool" ];
    };

    loader = {
      grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        mirroredBoots = [
          {
            devices = [ "nodev" ];
            path = "/boot";
          }
        ];
      };
      # systemd-boot.enable = true;
      # efi.canTouchEfiVariables = true;
    };
    # kernelModules = [ "nct6775" ];
  };

  # Networking
  networking = {
    hostId = "c67ef9f9";
    hostName = "luna";
    networkmanager.enable = true;
    interfaces = {
      enp34s0 = {
        ipv4.addresses = [
          {
            address = "10.0.0.71";
            # address = "192.168.68.54";
            prefixLength = 24;
          }
        ];
      };
    };
    # defaultGateway = "192.168.68.1";
    defaultGateway = "10.0.0.1";
    nameservers = [ "8.8.8.8" ];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Firewall settings
    firewall = {
      enable = true;
      allowPing = true;

      # Open ports in the firewall.
      allowedTCPPorts = [
        22
        3000
        11975
        21975
      ];
      allowedUDPPorts = [
        22
        3000
        11975
        21975
      ];
    };
  };

  # ZFS pool filesystem
  fileSystems."/zpool" = {
    device = "zpool/vault";
    fsType = "zfs";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      patrick = {
        isNormalUser = true;
        description = "Patrick Dewey";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "docker"
        ];
        packages = with pkgs; [
          typst
          pandoc
        ];
        shell = pkgs.zsh;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    zsh
    git
    curl
    wget
    gcc
    nodejs
    go
    htop
    fastfetch
    lshw
    lm_sensors
    ripgrep
    fzf
    tmux
    python312
    killall
    fd
    tree
    tree-sitter
    lsd
    jq
    tokei
    csvlens
    xan
    oh-my-posh
    rustup
    nvtopPackages.full
    cudaPackages.cuda_nvcc
    nvidia-modprobe
  ];

  virtualisation.docker = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # services.ollama = {
  #   package = unstablePkgs.ollama;
  #   enable = true;
  #   acceleration = "cuda";
  #   host = "0.0.0.0";
  #   openFirewall = true;
  # };

  # ZFS scrubbing (once a week)
  services.zfs.autoScrub.enable = true;

  # NFS
  services.nfs.server.enable = true;

  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "usershare owner only" = "yes";
        "map executable" = "no";
      };
      vault = {
        path = "/zpool";
        writeable = "yes";
        browseable = "yes";
        comment = "";
        "guest ok" = "no";
      };
    };
  };
  services.avahi = {
    enable = true;
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };
  services.samba-wsdd = {
    enable = true;
    discovery = true;
    openFirewall = true;
  };

  # Tailscale
  services.tailscale.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ sqlite ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
