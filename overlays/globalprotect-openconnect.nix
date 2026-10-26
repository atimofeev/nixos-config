# Temporary 3.x prerequisites for networkmanager-gpclient.
# Remove this overlay and its import once compatible 3.x packaging reaches our pinned nixpkgs.
# Combined gpclient/gpauth upgrade: https://github.com/NixOS/nixpkgs/pull/573002
# Related gpauth update: https://github.com/NixOS/nixpkgs/pull/577414
# Superseded initial attempt: https://github.com/NixOS/nixpkgs/pull/572690
final: prev:
let
  runtimePath = prev.lib.makeBinPath [
    prev.coreutils
    prev.gawk
    prev.iproute2
    prev.pciutils
    prev.procps
    prev.systemd
  ];
  version = "3.2.0";
  src = prev.fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "915c130c708582a61bbd5ccf747f94347d732364";
    hash = "sha256-nQl+zXsO+8hxZ+RLPA+hxEX7FhM2GN22Qb1sTFxvPKk=";
    fetchSubmodules = true;
  };
  cargoHash = "sha256-CqcGbfsIMSnCYUwvgC+jXDINJr9zaLHgc8VsOmHT1go=";
  cargoDeps = prev.rustPlatform.fetchCargoVendor {
    inherit src;
    name = "globalprotect-openconnect-${version}";
    hash = cargoHash;
  };
in
{
  gpauth = prev.gpauth.overrideAttrs {
    inherit
      cargoDeps
      cargoHash
      src
      version
      ;
  };

  gpclient = (prev.gpclient.override { gpauth = final.gpauth; }).overrideAttrs (old: {
    inherit
      cargoDeps
      cargoHash
      src
      version
      ;

    # Diagnostics are unused here; its test hardcodes an FHS PATH. Drop when nixpkgs PR #573002 lands.
    checkFlags = (old.checkFlags or [ ]) ++ [
      "--skip=embedded_collector_reports_missing_helpers_without_recursing_or_exposing_private_environment"
    ];

    # Upstream now discovers vpnc-script relative to the installed executable.
    postPatch = "";
    postInstall = ''
      install -Dm755 packaging/files/usr/libexec/gpclient/vpnc-script \
        $out/libexec/gpclient/vpnc-script
      substituteInPlace $out/libexec/gpclient/vpnc-script \
        --replace-fail /sbin/resolvconf ${prev.openresolv}/bin/resolvconf \
        --replace-fail /usr/bin/resolvectl ${prev.systemd}/bin/resolvectl \
        --replace-fail /usr/bin/busctl ${prev.systemd}/bin/busctl
      wrapProgram "$out/libexec/gpclient/vpnc-script" \
        --prefix PATH : "${
          prev.lib.makeBinPath [
            prev.coreutils
            prev.gawk
            prev.gnugrep
            prev.gnused
            prev.net-tools
            prev.iproute2
            prev.openresolv
          ]
        }"
    '';
    postFixup = ''
      wrapProgram "$out/bin/gpclient" \
        --prefix GIO_EXTRA_MODULES : ${prev.glib-networking}/lib/gio/modules \
        --prefix PATH : "${runtimePath}" \
        --prefix GP_COMMAND_PATH : "${runtimePath}" \
        --set-default GP_AUTH_BINARY ${final.gpauth}/bin/gpauth
    '';
  });
}
