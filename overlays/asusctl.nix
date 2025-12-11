# NOTE: https://github.com/NixOS/nixpkgs/pull/468836
{
  lib,
  pkgs,
  ...
}:
(_final: prev: {
  asusctl = prev.asusctl.override (old: {
    rustPlatform = old.rustPlatform // {
      buildRustPackage =
        args:
        old.rustPlatform.buildRustPackage (
          args
          // rec {
            version = "6.1.22";
            src = prev.fetchFromGitLab {
              owner = "asus-linux";
              repo = "asusctl";
              tag = version;
              sha256 = "sha256-cAHZdxXBCQBh1erhjm8dMF1C5w4Tth00KxwLf8+miHQ=";
            };
            cargoHash = "sha256-gTHUvCwdRqBR0nV5trHpv0XMYJ7kVincfxeptsDUizw=";

            postPatch = ''
              files="
                asusd-user/src/config.rs
                asusd-user/src/daemon.rs
                asusd/src/aura_anime/config.rs
                rog-aura/src/aura_detection.rs
                rog-control-center/src/lib.rs
                rog-control-center/src/main.rs
                rog-control-center/src/tray.rs
              "
              for file in $files; do
                substituteInPlace $file --replace-fail /usr/share $out/share
              done

              substituteInPlace rog-control-center/src/main.rs \
                --replace-fail 'std::env::var("RUST_TRANSLATIONS").is_ok()' 'true'

              substituteInPlace data/asusd.service \
                --replace-fail /usr/bin/asusd $out/bin/asusd \
                --replace-fail /bin/sleep ${lib.getExe' pkgs.coreutils "sleep"}
              substituteInPlace data/asusd-user.service \
                --replace-fail /usr/bin/asusd-user $out/bin/asusd-user \
                --replace-fail /usr/bin/sleep ${lib.getExe' pkgs.coreutils "sleep"}

              substituteInPlace Makefile \
                --replace-fail /usr/bin/grep ${lib.getExe pkgs.gnugrep}

              substituteInPlace /build/asusctl-${version}-vendor/sg-0.4.0/build.rs \
                --replace-fail /usr/include ${lib.getDev pkgs.glibc}/include
            '';
          }
        );
    };
  });
})
