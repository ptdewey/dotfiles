{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  defaultBrowser = "glide-browser.desktop";
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelModules = [ "kvm-amd" ];

  # boot.initrd.kernelModules = [ "amdgpu" ];
  # hardware.graphics.extraPackages = with pkgs; [ amdvlk ];
  # hardware.graphics.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  networking = {
    hostName = "europa";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networkmanager = {
      enable = true;
      dns = "none";
    };

    nameservers = [
      "192.168.4.71"
      "1.1.1.1"
      "8.8.8.8"
    ];

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ 8000 ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    extraHosts = ''
      192.168.4.71 luna
      167.172.231.73 arabica-systems-pds
    '';
  };

  hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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

  services.printing.enable = true;

  services.local-observability.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick Dewey";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "dialout"
    ];
    packages = with pkgs; [ ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  xdg.mime.defaultApplications = {
    "text/html" = defaultBrowser;
    "x-scheme-handler/http" = defaultBrowser;
    "x-scheme-handler/https" = defaultBrowser;
    "x-scheme-handler/about" = defaultBrowser;
    "x-scheme-handler/unknown" = defaultBrowser;
  };
  environment.sessionVariables.BROWSER = lib.removeSuffix ".desktop" defaultBrowser;

  environment.systemPackages = with pkgs; [
    vim
    wezterm
    spotify
    # discord
    nvtopPackages.amd
    xclip
    lact
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    qmk
    audacity
    vulkan-tools
    obsidian
    love
    protonmail-desktop
    proton-vpn
    proton-authenticator
    proton-pass
    picard
    yt-dlp
    templ
    tailwindcss
    inkscape
    inputs.glide.packages.${pkgs.system}.default
    onefetch
    # openmw # FIX: build is failing?
    # kdePackages.kdenlive # FIX: build is failing (01/28/26)
    gleam
    beam28Packages.erlang
    beam28Packages.elixir
    beam28Packages.rebar3
    qemu_kvm
    rusty-path-of-building
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
    inputs.qbz.packages.${pkgs.system}.default
    helix
  ];

  # TODO: I don't think I actually use these
  services.udev.packages = with pkgs; [
    qmk
    qmk-udev-rules
    qmk_hid
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  # TODO: pin a version of ollama to avoid long build times
  # services.ollama = {
  #   package = pkgs.ollama-rocm;
  #   enable = true;
  #   host = "0.0.0.0";
  #   # rocmOverrideGfx = "11.0.0";
  # };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.tailscale.enable = true;

  # Allow cross compilation of armv8
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.ssh = {
    # Tangled vm local dev config
    extraConfig = ''
      Host nixos-shell
          Hostname localhost
          Port 2222
          User git
          IdentityFile ~/.ssh/id_ed25519.pub

      Host knot.example.com
          HostName knot.solanaceae.net
          User git
          Port 2222
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
