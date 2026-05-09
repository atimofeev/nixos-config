{ lib, ... }:

let

  softSpring.spring._props = {
    damping-ratio = 0.85;
    stiffness = 1500;
    epsilon = 0.0001;
  };

  stiffSpring.spring._props = {
    damping-ratio = 0.95;
    stiffness = 2000;
    epsilon = 0.0001;
  };

  softAnimations = [
    "window-close"
    "window-movement"
    "window-open"
    "window-resize"
  ];

  stiffAnimations = [
    "horizontal-view-movement"
    "workspace-switch"
  ];

in
{
  wayland.windowManager.niri.settings.animations =
    (lib.genAttrs softAnimations (_: softSpring)) // (lib.genAttrs stiffAnimations (_: stiffSpring));
}
