{ lib, pkgs, ... }:
{

  imports = [

    ./apps/gtk.nix
    ./apps/hyprdynamicmonitors.nix
    ./apps/hypridle.nix
    ./apps/hyprlock.nix
    ./apps/hyprpanel.nix
    ./apps/hyprpaper.nix # wallpaper
    ./apps/hyprsunset.nix
    ./apps/per-window-layout.nix
    ./apps/qt.nix
    ./apps/rofi.nix
    ./apps/xdg-mime.nix # file association
    # ./apps/walker.nix

    ./animations.nix
    ./cursor.nix
    ./decorations.nix
    ./input.nix
    ./keybinds.nix
    ./tiling.nix
    ./window-rules.nix
    ./workspaces.nix

  ];

  home.packages = with pkgs; [
    hyprpicker
    libnotify
    networkmanagerapplet # bin: nm-connection-editor
    blueman # bin: blueman-manager
    pwvucontrol
    snapshot
  ];

  custom-hm.services = {
    wayland-pipewire-idle-inhibit.enable = lib.mkDefault true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      misc = {
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };
      xwayland.force_zero_scaling = true;
    };
  };

}
