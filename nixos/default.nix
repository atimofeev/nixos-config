{ inputs, pkgs, config, libx, vars, ... }: {
  imports = [
    ./games
    ./homepage
    ./work
    ./apps.nix # various GUI or TUI apps
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix # desktop environment setup
    ./flatpak.nix
    ./hardware-configuration.nix
    ./intel.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./power.nix
    ./sops.nix
    ./sound.nix
    ./ssd.nix
    ./sudo.nix
    ./syncthing.nix
    ./user.nix
    ./utils.nix # various CLI utils
    ./xremap.nix
  ];

  system.stateVersion = vars.nix.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.hyprpanel.overlay
      (import ../overlays/unstable.nix { inherit inputs; })
      (import ../overlays/terraformer.nix)
      (import ../overlays/neovim-unwrapped.nix)
      (import ../overlays/manix.nix)
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

  # fix spotify API bug
  networking.extraHosts = ''
    0.0.0.0 apresolve.spotify.com
  '';

}
