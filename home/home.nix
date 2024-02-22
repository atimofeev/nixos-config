# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, vars, ... }: {
  imports = [
    ./hyprland
    #./firefox.nix
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./kitty.nix
    ./mpv.nix
    ./nvim.nix
    ./starship.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = vars.nix.stateVersion;
  programs.home-manager.enable = true;
  systemd.user.startServices =
    "sd-switch"; # reload system units on config update

  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*.devspt.com".extraOptions = {
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "/dev/null";
        LogLevel = "ERROR";
      };
      "kafka-prd-htz-jump-host".extraOptions = {
        HostName = "mongo1-prd-hidden-ams1.devspt.com";
      };
      "kafka-prd-htz-node*.devspt.com".extraOptions = {
        ProxyJump = "kafka-prd-htz-jump-host";
      };
    };
  };
}
