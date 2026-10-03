{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.gpu-ordering;
  dock = cfg.dgpuDock;
  dockUser = config.custom.hm-admin;
  dockScript = pkgs.callPackage ../../pkgs/niri-dgpu-dock.nix {
    dgpuPath = dock.dgpuPath;
    fragmentPath = "${config.users.users.${dockUser}.home}/.config/niri/dgpu-dock.kdl";
    owner = dockUser;
  };
in
{

  options.custom.hardware.gpu-ordering = {
    enable = lib.mkEnableOption "GPU ordering bundle";
    dgpu = lib.mkOption {
      description = "vendor:device for dGPU";
      type = lib.types.str;
      example = "0x8086:0x7d51";
    };
    igpu = lib.mkOption {
      description = "vendor:device for iGPU";
      type = lib.types.str;
      example = "0x10de:0x2f58";
    };
    dgpuDock = {
      enable = lib.mkEnableOption ''
        leaving the dGPU out of the compositor (so it can runtime-suspend) and
        binding it only while a display is attached to one of its connectors
      '';
      dgpuPath = lib.mkOption {
        default = "/dev/dri/dgpu";
        description = "Stable symlink to the dGPU DRM card node.";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.sessionVariables = lib.mkIf config.programs.hyprland.enable {
      AQ_DRM_DEVICES = "/dev/dri/igpu:/dev/dri/dgpu";
    };

    services.udev.extraRules =
      let
        d = lib.splitString ":" cfg.dgpu;
        i = lib.splitString ":" cfg.igpu;
      in
      ''
        SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="${builtins.elemAt d 0}", ATTRS{device}=="${builtins.elemAt d 1}", SYMLINK+="dri/dgpu"
        SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="${builtins.elemAt i 0}", ATTRS{device}=="${builtins.elemAt i 1}", SYMLINK+="dri/igpu"
      ''
      + lib.optionalString dock.enable ''
        ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ATTRS{vendor}=="${builtins.elemAt d 0}", ATTRS{device}=="${builtins.elemAt d 1}", RUN+="${lib.getExe dockScript} auto"
      '';

    environment.systemPackages = lib.mkIf dock.enable [ dockScript ];

    systemd.tmpfiles.rules = lib.mkIf dock.enable [
      "f ${config.users.users.${dockUser}.home}/.config/niri/dgpu-dock.kdl 0644 ${dockUser} users -"
    ];

    systemd.services.niri-dgpu-dock = lib.mkIf dock.enable {
      description = "Bind dGPU to the compositor only while an external display is attached";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${dockScript}/bin/niri-dgpu-dock auto";
      };
    };

  };
}
