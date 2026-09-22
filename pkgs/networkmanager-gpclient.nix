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
  stdenv,
  systemd,
  xdg-utils,
}:

stdenv.mkDerivation {
  pname = "networkmanager-gpclient";
  version = "0.1.0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "jdpipe";
    repo = "networkmanager-gpclient";
    rev = "7189cf618cbf2f4ea921c520688408b30d0f9365";
    hash = "sha256-Vf6OG4Yhzf5NSc5QVTIqVU83VFM7sc81ODkjXWy/Zo4=";
  };

  postPatch = ''
    sed -i 's|^NM_PLUGIN_DIR=.*|NM_PLUGIN_DIR="$out/lib/NetworkManager"|' configure.ac
    substituteInPlace src/nm-gpclient-service.c \
      --replace-fail '"/usr/bin/gpclient"' '"${lib.getExe' gpclient "gpclient"}"' \
      --replace-fail '"/var/run/gpclient.lock"' '"/run/gpclient.lock"' \
      --replace-fail 'system ("/sbin/modprobe tun")' 'system ("${lib.getExe' kmod "modprobe"} tun")'
    substituteInPlace properties/nm-gpclient-editor.c \
      --replace-fail '"/usr/bin/gpclient"' '"${lib.getExe' gpclient "gpclient"}"'
    substituteInPlace auth-dialog/nm-gpclient-auth-dialog.c \
      --replace-fail 'g_ptr_array_add(argv, "gpauth");' \
        'g_ptr_array_add(argv, "${lib.getExe' gpauth "gpauth"}");' \
      --replace-fail $'\tg_ptr_array_add(argv, "--browser");\n\tg_ptr_array_add(argv, (gpointer) browser);' \
        $'\tif (strcmp(browser, "embedded") != 0) {\n\t\tg_ptr_array_add(argv, "--browser");\n\t\tg_ptr_array_add(argv, (gpointer) browser);\n\t}'
    substituteInPlace src/nm-gpclient-browser-helper \
      --replace-fail 'log=''${NM_GPCLIENT_BROWSER_LOG:-/tmp/nm-gpclient-browser-helper.log}' \
        'log=''${NM_GPCLIENT_BROWSER_LOG:-/dev/null}'
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
    "--with-gtk4=yes"
    "--with-sso-mib=no"
    "--without-libnm-glib"
  ];

  postInstall = ''
    install -Dm755 src/nm-gpclient-browser-helper \
      "$out/libexec/nm-gpclient-browser-helper"
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
