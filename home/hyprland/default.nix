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
    inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "${pkgs.hyprland-per-window-layout}/bin/hyprland-per-window-layout"
        "${pkgs.hyprpanel}/bin/hyprpanel"
        "systemctl --user start hyprpolkitagent"
      ];
    };
  };

}
