{ pkgs, vars, ... }: {
  imports = [
    ./hyprland
    ./bat.nix
    #./firefox.nix
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./htop.nix
    ./k9s.nix
    ./kitty.nix
    ./mpv.nix
    ./nvim.nix
    ./qbittorrent.nix
    ./spotify-player.nix
    ./ssh.nix
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
}
