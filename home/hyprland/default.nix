{ pkgs, inputs, ... }: {

  imports = [
    ./animations.nix
    ./cursor.nix
    ./gtk.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprsunset.nix
    ./input.nix
    ./keybinds.nix
    ./qt.nix
    ./settings.nix
    ./window-rules.nix
    ./workspaces.nix
  ];

  home.packages = with pkgs; [
    # sddm # display manager
    # dunst # notifications
    libnotify
    hyprpicker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "${pkgs.hyprpanel}/bin/hyprpanel"
        "${pkgs.hyprland-per-window-layout}/bin/hyprland-per-window-layout"
      ];
    };
  };

}
