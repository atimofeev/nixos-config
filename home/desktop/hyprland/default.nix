{ pkgs, ... }: {

  imports = [
    # ./hypridle.nix
    # ./hyprlock.nix
    ./animations.nix
    ./cursor.nix
    ./fuzzel.nix
    ./gtk.nix
    ./hyprpaper.nix
    ./hyprsunset.nix
    ./input.nix
    ./keybinds.nix
    ./per-window-layout.nix
    ./polkit-agent.nix
    ./qt.nix
    ./settings.nix
    ./swayidle-swaylock.nix
    ./window-rules.nix
    ./workspaces.nix
    ./xdg-mime.nix
  ];

  home.packages = with pkgs; [
    # sddm # display manager
    # dunst # notifications
    hyprpicker
    hyprlauncher
    libnotify
    # FIX: some icons are missing
    networkmanagerapplet # bin: nm-connection-editor
    blueman # bin: blueman-manager
    pwvucontrol
    snapshot
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.hyprpanel}/bin/hyprpanel"
      ];
    };
  };

}
