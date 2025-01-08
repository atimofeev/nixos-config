{ inputs, pkgs, config, libx, vars, ... }: {
  imports = [
    ../overlays
    ../pkgs
    ./games
    ./homepage
    ./work

    ./apps.nix # various GUI or TUI apps
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix # desktop environment setup
    # ./flatpak.nix
    ./hardware-configuration.nix
    ./intel.nix
    ./locale.nix
    ./logind.nix
    # ./nbfc.nix # breaks bluetooth
    ./network.nix
    ./nvidia.nix
    ./ollama.nix
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

  system = {
    inherit (vars.nix) stateVersion;

    activationScripts.diff = ''
      if [[ -e /run/current-system ]]; then
        ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
      fi
    '';
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = vars.tz_name;

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; })
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # for Hyprpanel
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs libx vars; };
    users = { ${vars.username} = import ../home; };
  };

  # (?)fix connection issues with Razer Basilisk X Hyperspeed
  # needs gnome-session.target?
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

  # # fix spotify API bug
  # networking.extraHosts = ''
  #   0.0.0.0 apresolve.spotify.com
  # '';

}
