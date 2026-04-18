{ lib, ... }:

let

  softSpring.spring = {
    damping-ratio = 0.85;
    stiffness = 1500;
    epsilon = 0.0001;
  };

  stiffSpring.spring = {
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
  programs.niri.settings.animations = {
    enable = true;
  }
  // lib.genAttrs softAnimations (_: {
    enable = true;
    kind = softSpring;
  })
  // lib.genAttrs stiffAnimations (_: {
    enable = true;
    kind = stiffSpring;
  });
}
