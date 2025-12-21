{ lib, pkgs, ... }:
{

  imports = [

    ./apps/gtk.nix
    ./apps/hyprlock.nix
    ./apps/qt.nix
    ./apps/xdg-mime.nix # file association

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
    libnotify
    snapshot
  ];

  custom-hm.services = {
    hyprdynamicmonitors.enable = lib.mkDefault true;
    hyprland-per-window-layout.enable = lib.mkDefault true;
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

  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      max_fps = 60
      allow_token_by_default = true
    }
  '';

}
