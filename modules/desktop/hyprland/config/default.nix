{ pkgs, inputs, ... }: {

  imports = [
    ./apps/fuzzel.nix # launcher
    ./apps/gtk.nix
    # ./apps/hypridle.nix
    # ./apps/hyprlock.nix
    ./apps/hyprpaper.nix # wallpaper
    ./apps/per-window-layout.nix
    ./apps/polkit-agent.nix # sudo password prompt
    ./apps/qt.nix
    ./apps/swayidle.nix
    ./apps/swaylock.nix
    ./apps/wayland-pipewire-idle-inhibit.nix
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
    hyprpicker
    libnotify
    networkmanagerapplet # bin: nm-connection-editor
    blueman # bin: blueman-manager
    pwvucontrol
    snapshot
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.hyprpanel}/bin/hyprpanel"
      ];

      monitor = [
        "desc:BOE 0x0747, preferred, 0x0, 1"
        "desc:Dell Inc. DELL P2422H 8WRR0V3, preferred, 1920x0, 1"
        "desc:Dell Inc. DELL P2422H 6FZG7N3, preferred, auto, 1"
        "desc:Lenovo Group Limited M14t V309WMZ3, preferred, auto, 1.2"
      ];

      xwayland.force_zero_scaling = true;

    };
  };

}