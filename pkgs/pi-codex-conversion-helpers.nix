{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  openssl_3,
}:
let
  version = "3.0.0";
in
stdenv.mkDerivation {
  pname = "pi-codex-conversion-helpers";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@howaboua/pi-codex-conversion/-/pi-codex-conversion-${version}.tgz";
    hash = "sha256-96Y7sEeThEMKrGI4XZce4rmH37Ohfk05g6SHAzXBuZ0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ openssl_3 stdenv.cc.cc.lib ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    for bin in exec_bridge apply_patch imagegen view_image web_run; do
      binpath=$(find package -path "*/bin/linux-x64/$bin" ! -name "*.exe" -type f -print -quit)
      if [ -n "$binpath" ] && [ -f "$binpath" ]; then
        cp "$binpath" "$out/bin/$bin"
        chmod +x "$out/bin/$bin"
      else
        echo "WARNING: binary $bin not found in tarball" >&2
      fi
    done

    found=$(ls -1 "$out/bin" | wc -l)
    if [ "$found" -ne 5 ]; then
      echo "ERROR: expected 5 helper binaries, found $found: $(ls "$out/bin")" >&2
      exit 1
    fi
  '';

  meta = {
    description = "Patched native helper binaries for pi-codex-conversion on NixOS";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
