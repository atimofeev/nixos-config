{ pkgs, pkgs-unstable, inputs, vars, ... }: {
  imports = [
    ./apps.nix # various GUI or TUI apps
    ./boot.nix
    ./desktop.nix # desktop environment setup
    ./games.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./power.nix
    ./sound.nix
    ./user.nix
    ./utils.nix # various CLI utils
    ./work.nix # apps for work
  ];

  system.stateVersion = vars.nix.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = vars.tz_name;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; }) ];

  home-manager = {
    extraSpecialArgs = { inherit pkgs pkgs-unstable inputs vars; };
    users = { ${vars.username} = import ../home/home.nix; };
  };

  environment.systemPackages = (with pkgs; [
    python3
    yamlfix
    #go
    #rust
  ]) ++ (with pkgs-unstable;
    [
      # yamlfix 
    ]);
}
