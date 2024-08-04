{ vars, ... }: {
  imports = [
    ./gnome
    # ./hyprland
    ./nvim
    
    ./bat.nix
    #./firefox.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./k9s.nix
    ./kitty.nix
    ./mpv.nix
    ./qbittorrent.nix
    ./spotify-player.nix
    ./ssh.nix
    ./starship.nix
    ./vcv-rack.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = vars.nix.stateVersion;
  programs.home-manager.enable = true;
  systemd.user.startServices =
    "sd-switch"; # reload system units on config update

  home = {
    inherit (vars) username;
    homeDirectory = "/home/${vars.username}";
  };

  # Autoconnect for virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

}
