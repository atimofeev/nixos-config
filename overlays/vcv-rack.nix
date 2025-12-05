_final: prev: {
  vcv-rack = prev.vcv-rack.overrideAttrs (oldAttrs: {
    postFixup = oldAttrs.postFixup + ''
      wrapProgram $out/bin/Rack --unset WAYLAND_DISPLAY
    '';
  });
}
