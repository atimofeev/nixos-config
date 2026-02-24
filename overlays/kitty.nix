_final: prev: {
  kitty = prev.kitty.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/share/applications/kitty-open.desktop \
        --replace "Categories=System;TerminalEmulator;" "Categories=System;"
    '';
  });
}
