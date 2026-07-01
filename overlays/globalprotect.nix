_final: prev: {

  gp-saml-gui = prev.gp-saml-gui.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./patches/gp-saml-gui-cas-support.patch
    ];
  });

  networkmanager-openconnect = prev.networkmanager-openconnect.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./patches/nm-openconnect-gp-csd.patch
    ];
  });

  openconnect = prev.openconnect.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./patches/openconnect-gp-app-version.patch
    ];
  });

}
