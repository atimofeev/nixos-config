{ config, ... }:
{

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Return".action = spawn "kitty";
    "Mod+Q" = {
      action = close-window;
      repeat = false;
    };
    "Mod+O" = {
      action = toggle-overview;
      repeat = false;
    };

    "Mod+P".action = switch-preset-column-width;
    "Mod+Shift+F".action = toggle-window-floating;
    "Mod+F".action = fullscreen-window;

    # NOTE: remove?
    # "Mod+Space".action = switch-layout "next";

    # NOTE: won't build
    # "Print".action = screenshot;
    # "Ctrl+Print".action = screenshot-screen;
    # "Alt+Print".action = screenshot-window;

    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-down;
    "Mod+K".action = focus-window-up;
    "Mod+L".action = focus-column-right;

    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+0".action = focus-workspace 10;

    "Mod+Ctrl+H".action = move-column-left;
    "Mod+Ctrl+J".action = move-window-down;
    "Mod+Ctrl+K".action = move-window-up;
    "Mod+Ctrl+L".action = move-column-right;

    "Mod+Left".action = move-column-left;
    "Mod+Down".action = move-window-down;
    "Mod+Up".action = move-window-up;
    "Mod+Right".action = move-column-right;

    # NOTE: won't build
    # "Mod+Ctrl+1".action = move-window-to-workspace 1;
    # "Mod+Ctrl+2".action = move-window-to-workspace 2;
    # "Mod+Ctrl+3".action = move-window-to-workspace 3;
    # "Mod+Ctrl+4".action = move-window-to-workspace 4;
    # "Mod+Ctrl+5".action = move-window-to-workspace 5;
    # "Mod+Ctrl+6".action = move-window-to-workspace 6;
    # "Mod+Ctrl+7".action = move-window-to-workspace 7;
    # "Mod+Ctrl+8".action = move-window-to-workspace 8;
    # "Mod+Ctrl+9".action = move-window-to-workspace 9;
    # "Mod+Ctrl+0".action = move-window-to-workspace 10;

  };

}
