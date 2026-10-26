{
  autoreconfHook,
  coreutils,
  fetchFromGitHub,
  file,
  glib,
  gpauth,
  gpclient,
  gtk3,
  gtk4,
  kmod,
  lib,
  libnma,
  libxml2,
  makeWrapper,
  networkmanager,
  pkg-config,
  procps,
  python3,
  stdenv,
  systemd,
  xdg-utils,
}:

stdenv.mkDerivation {
  pname = "networkmanager-gpclient";
  version = "0.1.0-unstable-2026-10-25";

  src = fetchFromGitHub {
    owner = "jdpipe";
    repo = "networkmanager-gpclient";
    rev = "a170f43b616bad23c852dac44498dbfe384ae60b";
    hash = "sha256-RU3INfeXuerE4hy2sIV2wFkmczb59V7krVCg+f2pd3E=";
  };

  postPatch = ''
    # Embedded authentication is still missing upstream: jdpipe/networkmanager-gpclient#2.
    substituteInPlace auth-dialog/nm-gpclient-auth-dialog.c \
      --replace-fail $'\tg_ptr_array_add(argv, "--browser");\n\tg_ptr_array_add(argv, (gpointer) browser);' \
        $'\tif (strcmp(browser, "embedded") != 0) {\n\t\tg_ptr_array_add(argv, "--browser");\n\t\tg_ptr_array_add(argv, (gpointer) browser);\n\t}'
  '';

  nativeBuildInputs = [
    autoreconfHook
    file
    glib
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    gtk4
    libnma
    libxml2
    networkmanager
    systemd
  ];

  configureFlags = [
    "--disable-static"
    "--enable-absolute-paths"
    "--with-authdlg=yes"
    "--with-gnome=yes"
    "--with-gpauth=${lib.getExe' gpauth "gpauth"}"
    "--with-gpclient=${lib.getExe' gpclient "gpclient"}"
    "--with-gtk4=yes"
    "--with-modprobe=${lib.getExe' kmod "modprobe"}"
    "--with-nm-plugin-dir=${placeholder "out"}/lib/NetworkManager"
    "--with-nm-vpn-service-dir=${placeholder "out"}/lib/NetworkManager/VPN"
    "--with-sso-mib=no"
    "--without-libnm-glib"
  ];

  doCheck = true;
  doInstallCheck = true;
  nativeCheckInputs = [ python3 ];
  nativeInstallCheckInputs = [ python3 ];

  preCheck = ''
    patchShebangs tools
    substituteInPlace tools/test-auth-dialog-cancel.py \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'
  '';

  postCheck = ''
    ./tools/test-auth-dialog.sh
    ./tools/test-auth-dialog-quit.sh
    ./tools/test-editor-plugin.sh
    ./tools/test-packaging.sh
    substituteInPlace tools/test-auth-dialog.sh \
      --replace-fail 'DATA_VAL=default' 'DATA_VAL=embedded' \
      --replace-fail ' --browser default' ""
    ./tools/test-auth-dialog.sh
  '';

  postInstall = ''
    wrapProgram "$out/libexec/nm-gpclient-browser-helper" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          glib
          procps
          xdg-utils
        ]
      }
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    substituteInPlace tools/test-upstream-auth.sh \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'
    export GPCLIENT_TOP_SRCDIR="$TMPDIR/installed-helper-test"
    mkdir -p "$GPCLIENT_TOP_SRCDIR/src"
    ln -s "$out/libexec/nm-gpclient-browser-helper" \
      "$GPCLIENT_TOP_SRCDIR/src/nm-gpclient-browser-helper"
    bash tools/test-upstream-auth.sh \
      ${lib.getExe' gpclient "gpclient"} ${lib.getExe' gpauth "gpauth"}
    runHook postInstallCheck
  '';

  passthru = {
    networkManagerPlugin = "VPN/nm-gpclient-service.name";
    networkManagerRuntimeDeps = [ gpclient ];
  };

  meta = {
    description = "NetworkManager plugin using gpclient for GlobalProtect VPNs";
    homepage = "https://github.com/jdpipe/networkmanager-gpclient";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
