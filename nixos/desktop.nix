{ inputs, pkgs, vars, ... }: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = vars.kb_layouts;
    xkb.options = "grp:win_space_toggle";

    displayManager = {
      gdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = vars.username;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    #xwayland.enable = true;
  };

  # Wait for proper implementation: 
  # https://github.com/NixOS/nixpkgs/issues/234076
  services.xremap = {
    # withGnome = true;
    # withWlroots = true;
    userName = vars.username;
    config = {
      virtual_modifiers = [ "capslock" ];
      # modmap = [{
      #   name = "fix broken shift key";
      #   remap = { capslock = "shift_l"; };
      # }];
      keymap = [
        {
          # FIX: not working in GNOME or Hypr when installed system-wide
          name = "desktop apps";
          remap = { shift-super-o.launch = [ "kitty" "-e" "htop" ]; };
        }
        {
          name = "hjkl anywhere";
          remap = {
            capslock-h = "left";
            capslock-j = "down";
            capslock-k = "up";
            capslock-l = "right";
          };
        }
      ];
    };
  };
}
