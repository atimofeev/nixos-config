{ inputs, pkgs, libx, vars, ... }: {
  imports = [
    ./games
    ./homepage
    ./work
    ./apps.nix # various GUI or TUI apps
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix # desktop environment setup
    ./hardware-configuration.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./power.nix
    ./sops.nix
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
      (import ../overlays/master.nix { inherit inputs; })
      (import ../overlays/neovim-unwrapped.nix)
      # (import ../overlays/xone.nix { inherit pkgs; })
    ];
  };

  time.timeZone = vars.tz_name;

  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; }) ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs libx vars; };
    users = { ${vars.username} = import ../home; };
  };

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
        size = "25M";
        rotate = 4;
        compress = true;
        missingok = true;
        notifempty = true;
        copytruncate = true;
      };
    };
  };

}
