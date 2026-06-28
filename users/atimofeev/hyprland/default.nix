{ lib, pkgs, ... }:
{

  imports = [
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

  custom-hm = {
    services = {
      hyprdynamicmonitors.enable = lib.mkDefault true;
      hyprland-per-window-layout.enable = lib.mkDefault true;
      wayland-pipewire-idle-inhibit.enable = lib.mkDefault true;
    };

    system = {
      gtk.enable = lib.mkDefault true;
      qt.enable = lib.mkDefault true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # # Strip wayland-sessions to avoid duplicate DM entries
    # # (NixOS programs.hyprland.enable already provides them)
    # package = pkgs.hyprland.overrideAttrs (old: {
    #   postInstall = (old.postInstall or "") + ''
    #     rm -rf $out/share/wayland-sessions
    #   '';
    # });

    configType = "hyprlang";
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
