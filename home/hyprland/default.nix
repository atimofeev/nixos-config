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
    ./per-window-layout.nix
    ./polkit-agent.nix
    ./qt.nix
    ./settings.nix
    ./window-rules.nix
    ./workspaces.nix
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
        "${pkgs.hyprpanel}/bin/hyprpanel"
      ];
    };
  };

}
