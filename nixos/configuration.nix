{ inputs, pkgs, libx, vars, ... }: {
  imports = [
    ./games
    ./work
    ./apps.nix # various GUI or TUI apps
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix # desktop environment setup
    ./hardware-configuration.nix
    ./homepage.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./power.nix
    ./sound.nix
    ./sudo.nix
    ./user.nix
    ./utils.nix # various CLI utils
    ./xremap.nix
  ];

  system.stateVersion = vars.nix.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../overlays/unstable.nix { inherit inputs; })
      (import ../overlays/neovim-unwrapped.nix)
    ];
  };

  time.timeZone = vars.tz_name;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; }) ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs libx vars; };
    users = { ${vars.username} = import ../home/home.nix; };
  };

  environment.defaultPackages = with pkgs; [ python3 ];

  # (?)fix connection issues with Razer Basilisk X Hyperspeed
  hardware.openrazer = {
    enable = true;
    users = [ "${vars.username}" ];
    batteryNotifier.enable = false;
  };

  services.logrotate = {
    enable = true;
    settings = {
      "/home/${vars.username}/.local/state/nvim/*log" = {
        size = "50M";
        rotate = 4;
        compress = true;
        missingok = true;
        notifempty = true;
        copytruncate = true;
      };
    };

  };
}
