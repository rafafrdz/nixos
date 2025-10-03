# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  ##############################################################################
  # Imports
  ##############################################################################
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  ##############################################################################
  # Boot
  ##############################################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nomodeset" ];

  ##############################################################################
  # Nix / Nixpkgs
  ##############################################################################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ##############################################################################
  # Networking
  ##############################################################################
  networking = {
    hostName = "server";
    networkmanager.enable = true;
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # networking.firewall.enable = false;
  };

  # Kubernetes
  networking.firewall = {
            allowedTCPPorts = [ 6443 ];
            allowedUDPPorts = [ 8472 ];
  };

  ##############################################################################
  # Locale & Time
  ##############################################################################
  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT    = "es_ES.UTF-8";
    LC_MONETARY       = "es_ES.UTF-8";
    LC_NAME           = "es_ES.UTF-8";
    LC_NUMERIC        = "es_ES.UTF-8";
    LC_PAPER          = "es_ES.UTF-8";
    LC_TELEPHONE      = "es_ES.UTF-8";
    LC_TIME           = "es_ES.UTF-8";
  };

  # XKB (si usas X11)
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  ##############################################################################
  # Users
  ##############################################################################
  users.users.pepino = {
    isNormalUser  = true;
    description   = "pepino";
    shell         = pkgs.zsh;
    extraGroups   = [ "networkmanager" "wheel" "docker" ];
    packages      = with pkgs; [ ];
  };

  users.users.root.shell = pkgs.zsh;

  ##############################################################################
  # Shells & Packages
  ##############################################################################
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    # Edición / desarrollo
    vim
    neovim
    meld
    gcc
    pkg-config
    protobuf
    python311
    lldb
    k3s_1_33
    k9s
    lazygit
    lazydocker
    kubectl

    # Rust toolchain
    rustc
    cargo
    rustup
    rust-analyzer

    # Networking / sistema
    curl
    wget
    git
    tailscale
    docker

    # CLI moderna
    fzf
    btop
    httpie
    xh
    dysk
    bat
    eza
    ripgrep
    fd
    nitch

    # SSL/CA
    openssl
    cacert
  ];

  # Variables de entorno útiles para compilar con OpenSSL / Python
  environment.variables = {
    OPENSSL_LIB_DIR     = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH     = "${pkgs.openssl.dev}/lib/pkgconfig";
    PYTHON              = "${pkgs.python311}/bin/python3";
    EDITOR              = "vim";
  };

  ##############################################################################
  # Programs
  ##############################################################################
  programs.zsh = {
    enable = true;
    autosuggestions.enable     = true;
    syntaxHighlighting.enable  = true;

    ohMyZsh = {
      enable  = true;
      theme   = "agnoster"; # Cambia por tu favorito si quieres
      plugins = [ "git" "docker" "kubectl" "sudo" ];
    };
  };

  ##############################################################################
  # Fonts
  ##############################################################################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # nerd-fonts.meslo-lg  # Alternativa si prefieres Meslo
  ];

  ##############################################################################
  # Services
  ##############################################################################
  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin       = "yes";
      PasswordAuthentication = true;
    };
  };
  # Kubernetes
  services.k3s = {
    enable = true;
    role = "server";
  };

  # Login automático en TTY
  services.getty.autologinUser = "pepino";

  # Tailscale
  services.tailscale.enable = true;

  ##############################################################################
  # Virtualization
  ##############################################################################
  virtualisation.docker.enable = true;

  ##############################################################################
  # System State
  ##############################################################################
  # Mantén este valor en el de la primera instalación del sistema.
  system.stateVersion = "25.05";
}

