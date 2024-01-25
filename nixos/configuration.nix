# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, vars, ... }: {
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
  time.timeZone = vars.tz_name;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; }) ];

  home-manager = {
    extraSpecialArgs = { inherit inputs vars; };
    users = { ${vars.username} = import ../home/home.nix; };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    #xwayland.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO: categorize 
  environment.systemPackages = with pkgs; [
    firefox
    chrome-gnome-shell
    coreutils
    curl
    fd
    ripgrep
    file
    wget
    htop
    # nvtop
    spotify-player
    nmap
    unzip
    util-linux
    telegram-desktop
    jq
    ansible
    terraform
    minikube
    kubectl
    k9s
    kubernetes-helm
    slack
    prusa-slicer
    eza
    bat
    python3
  ];

  system.stateVersion = "23.11";
}
