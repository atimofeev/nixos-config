{ pkgs, pkgs-unstable, inputs, libx, vars, ... }: {
  imports = [
    ./apps.nix # various GUI or TUI apps
    ./bluetooth.nix
    ./boot.nix
    ./desktop.nix # desktop environment setup
    ./games.nix
    ./hardware-configuration.nix
    ./homepage.nix
    ./locale.nix
    ./network.nix
    ./nvidia.nix
    ./power.nix
    ./sound.nix
    ./user.nix
    ./utils.nix # various CLI utils
    ./work # apps for work
  ];

  # TODO: nix-sops or something with AES256 encryption

  system.stateVersion = vars.nix.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = vars.tz_name;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; }) ];

  home-manager = {
    extraSpecialArgs = { inherit pkgs pkgs-unstable inputs libx vars; };
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
