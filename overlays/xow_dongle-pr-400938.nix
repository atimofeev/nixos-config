final: prev: {
  xow_dongle-firmware =
    let
      xow_dongle-firmware-pr-400938 =
        import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/3ede1df8529d14f1ff261e1ce4f284ee71b255ca.tar.gz";
            sha256 = "sha256:075y0yfl0i6l0qx2gqkv6b76jfymkqy1j0znx0y8y34knv8hcaik";
          })
          {
            inherit (final) system;
            config.allowUnfree = true;
          };
    in
    xow_dongle-firmware-pr-400938.xow_dongle-firmware;
}
