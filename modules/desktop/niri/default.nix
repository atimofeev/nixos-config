{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.niri;
in
{

  options.custom.desktop.niri = {
    enable = lib.mkEnableOption "Niri desktop bundle";
    package = lib.mkPackageOption pkgs.unstable "niri" { };
    useNautilus = lib.mkOption {
      default = true;
      description = "Install Nautilus support for Niri portal screen sharing.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        GSK_RENDERER = "cairo"; # NOTE: https://github.com/NixOS/nixpkgs/issues/353990
        NIXOS_OZONE_WL = "1"; # wayland for electron apps
      };
      systemPackages = [ pkgs.unstable.xwayland-satellite ];
    };

    programs = {
      niri = {
        enable = true;
        inherit (cfg) package useNautilus;
      };

      uwsm = {
        enable = lib.mkDefault true;
        waylandCompositors.niri = {
          binPath = "/run/current-system/sw/bin/niri-session";
          comment = "A scrollable-tiling Wayland compositor";
          prettyName = "Niri";
        };
      };
    };

  };

}
