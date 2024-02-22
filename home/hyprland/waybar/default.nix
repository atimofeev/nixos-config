{ pkgs, vars, ... }: {
  imports = [ ./modules.nix ./settings.nix ./style.nix ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };

  home.packages = with pkgs; [ waybar-mpris ];
}
