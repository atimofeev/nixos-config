{

  wayland.windowManager.niri.settings = {
    debug = {
      honor-xdg-activation-with-invalid-serial = { }; # NOTE: fix for callbacks & window activation
      # NOTE: fix for iGPU vs dGPU performance issues when multiple monitors are connected
      # disable-cursor-plane = { };
      # disable-direct-scanout = { };
      # enable-overlay-planes = { };
      # NOTE: fix for glitchy dual-monitor output from single type-c port; itself causes lag, stutter
      wait-for-frame-completion-before-queueing = { };
    };
  };

}
