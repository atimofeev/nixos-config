_final: prev: {
  cato-client = prev.cato-client.overrideAttrs (_oldAttrs: rec {
    version = "5.6.0.4138";
    src = prev.fetchurl {
      url = "https://clients.catonetworks.com/linux/${version}/cato-client-install.deb";
      sha256 = "sha256-NMhLlyQckFEvCJ1sPZ9sTa5MhT1EahnNU2Hkr+jonNg=";
    };
  });
}
