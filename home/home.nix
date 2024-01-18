# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, vars, ... }: {
  imports = [
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
  };

  # Add stuff for your user as you see fit:
  # home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
