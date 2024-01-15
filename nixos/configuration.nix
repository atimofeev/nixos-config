# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  imports = [
    ./boot.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./network.nix
    ./power.nix
    ./sound.nix
    ./user.nix
    ./x11.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  # TODO: tz_name: use global variable
  time.timeZone = "Asia/Tbilisi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # TODO: font_name: use global variable
  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ];

  # TODO: username: use global variable
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "atimofeev" = import ../home/home.nix; };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO: categorize 
  environment.systemPackages = with pkgs; [
    xclip
    gcc
    nodejs_21
    go
    cargo
    chrome-gnome-shell
    coreutils
    curl
    fd
    ripgrep
    file
    git
    kitty
    neovim
    wget
    htop
    # nvtop
    spotify-player
    glances
    nmap
    unzip
    util-linux
    telegram-desktop
    starship
    fish
    jq
    statix
    nixfmt
    nixpkgs-fmt
    ansible
    terraform
    minikube
    kubectl
    k9s
    kubernetes-helm
  ];

  system.stateVersion = "23.11";
}
