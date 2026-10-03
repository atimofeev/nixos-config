{
  lib,
  osConfig,
  ...
}:
let
  dgpuDock = osConfig.custom.hardware.gpu-ordering.dgpuDock.enable;
in
{

  # Writable fragment rewritten by niri-dgpu-dock: keeps the dGPU out of the
  # compositor (so it can runtime-suspend) unless an output is attached to it.
  wayland.windowManager.niri.settings.include = lib.mkIf dgpuDock [ "dgpu-dock.kdl" ];

  # Manual override, for when hot-plug detection cannot wake a suspended dGPU.
  wayland.windowManager.niri.settings.binds = lib.mkIf dgpuDock {
    "Mod+Shift+D".spawn = [
      "/run/current-system/sw/bin/niri-dgpu-dock"
      "toggle"
    ];
    "Mod+Shift+Ctrl+D".spawn = [
      "/run/current-system/sw/bin/niri-dgpu-dock"
      "auto"
    ];
  };

}
