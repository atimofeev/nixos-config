{

  wayland.windowManager.niri.settings = {
    debug = {
      honor-xdg-activation-with-invalid-serial = { }; # NOTE: fix for callbacks & window activation
      # NOTE: fix for iGPU vs dGPU performance issues when multiple monitors are connected
      disable-cursor-plane = { };
      # enable-overlay-planes = { };
      # wait-for-frame-completion-before-queueing = { };
    };
  };

}
