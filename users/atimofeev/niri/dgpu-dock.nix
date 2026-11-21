{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  fragment = "${config.xdg.configHome}/niri/dgpu-dock.kdl";
  package = pkgs.callPackage ../../../pkgs/niri-dgpu-dock.nix { };
  command = [
    (lib.getExe package)
    "--fragment"
    fragment
    "--niri"
    (lib.getExe osConfig.programs.niri.package)
  ];
in
lib.mkIf osConfig.custom.desktop.niri.dgpuDock {
  assertions = [
    {
      assertion = osConfig.custom.hardware.gpu-ordering.enable;
      message = "Niri dGPU docking needs GPU ordering's /dev/dri/dgpu symlink.";
    }
  ];

  home = {
    activation.initializeDgpuDock = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
      run ${lib.getExe package} init --fragment ${lib.escapeShellArg fragment}
    '';
    packages = [ package ];
  };

  systemd.user.services.niri-dgpu-dock = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
      ExecStart = lib.escapeShellArgs (command ++ [ "watch" ]);
      NoNewPrivileges = true;
      Restart = "on-failure";
      RestartSec = 5;
      RestrictSUIDSGID = true;
      UMask = "0077";
    };
    Unit = {
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "NIRI_SOCKET";
      Description = "Ignore Niri's dGPU on battery when no display is attached";
      PartOf = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.niri.settings.include = [
    { _args = [ "dgpu-dock.kdl" ]; }
  ];
}
