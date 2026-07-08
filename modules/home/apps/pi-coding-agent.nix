{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.pi-coding-agent;

  wrappedPkg = cfg.package.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      wrapProgram "$out/bin/pi" \
        --set NPM_CONFIG_PREFIX "/home/atimofeev/.pi/npm/" \
        --set AWS_PROFILE "ai" \
        --set PI_SKIP_VERSION_CHECK 1 \
        --set PI_TELEMETRY 0 \
        --prefix PATH : "${
          lib.makeBinPath [
            pkgs.ripgrep
            pkgs.nodejs_latest
          ]
        }" \
        --prefix LD_LIBRARY_PATH : "${pkgs.stdenv.cc.cc.lib}/lib"
    '';
  });

in
{
  options.custom-hm.applications.pi-coding-agent = {
    enable = lib.mkEnableOption "pi-coding-agent bundle";
    package = lib.mkPackageOption pkgs "pi-coding-agent" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPkg ];
  };
}
