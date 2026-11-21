{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  enabled = osConfig.custom.desktop.niri.nvidiaMstWorkaround;
  fragment = "${config.xdg.configHome}/niri/nvidia-mst.kdl";
  package = pkgs.callPackage ../../../pkgs/niri-nvidia-mst {
    nvidiaPackage = osConfig.hardware.nvidia.package;
  };
in
lib.mkIf enabled {
  assertions = [
    {
      assertion = osConfig.custom.hardware.gpu-ordering.enable && osConfig.hardware.nvidia.open;
      message = "The Niri MST workaround needs GPU ordering and the NVIDIA open driver.";
    }
  ];

  home = {
    activation.initializeNvidiaMst = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
      run ${lib.getExe package} init --fragment ${lib.escapeShellArg fragment}
    '';
    packages = [ package ];
  };

  systemd.user.services.niri-nvidia-mst = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe package)
        "watch"
        "--fragment"
        fragment
        "--gpu"
        "/dev/dri/dgpu"
        "--niri"
        (lib.getExe osConfig.programs.niri.package)
      ];
      NoNewPrivileges = true;
      Restart = "on-failure";
      RestartSec = 5;
      RestrictSUIDSGID = true;
      UMask = "0077";
    };
    Unit = {
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "NIRI_SOCKET";
      Description = "Enable Niri frame-completion workaround for active NVIDIA MST displays";
      PartOf = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.niri.settings.include = [
    { _args = [ "nvidia-mst.kdl" ]; }
  ];
}
