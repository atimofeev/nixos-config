{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.rapl-power-limit;
  asusctlPkg = config.custom.hardware.asus.asus-linux.package;

  profileCases = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: limits: ''
      ${name})
        PL1=${toString (limits.pl1Watts * 1000000)}
        PL2=${toString (limits.pl2Watts * 1000000)}
        ;;
    '') cfg.profiles
  );

  applyRaplScript = pkgs.writeShellScript "apply-rapl" ''
    RAPL_DIR="/sys/class/powercap/intel-rapl:0"
    [ -d "$RAPL_DIR" ] || { echo "RAPL directory not found."; exit 0; }

    PROFILE=$(${asusctlPkg}/bin/asusctl profile get 2>/dev/null \
      | grep -oP 'Active profile: \K\w+' \
      | tr '[:upper:]' '[:lower:]' || echo "balanced")

    case "$PROFILE" in
    ${profileCases}
    *)
      PL1=${toString (cfg.profiles.balanced.pl1Watts * 1000000)}
      PL2=${toString (cfg.profiles.balanced.pl2Watts * 1000000)}
      ;;
    esac

    CUR_PL1=$(cat "$RAPL_DIR/constraint_0_power_limit_uw" 2>/dev/null || echo 0)
    if [ "$CUR_PL1" != "$PL1" ]; then
      echo "$PL1" > "$RAPL_DIR/constraint_0_power_limit_uw" 2>/dev/null || true
      echo "$PL2" > "$RAPL_DIR/constraint_1_power_limit_uw" 2>/dev/null || true
      echo "Applied RAPL limits for '$PROFILE': PL1=$((PL1/1000000))W, PL2=$((PL2/1000000))W"
    fi
  '';

in
{
  options.custom.hardware.rapl-power-limit = {
    enable = lib.mkEnableOption "Intel RAPL power limits synced with asusd profile";

    profiles = lib.mkOption {
      description = "Per-profile PL1/PL2 overrides in watts. Keys: quiet, balanced, performance.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            pl1Watts = lib.mkOption {
              type = lib.types.int;
              description = "PL1 sustained limit";
            };
            pl2Watts = lib.mkOption {
              type = lib.types.int;
              description = "PL2 burst limit";
            };
          };
        }
      );
      default = {
        quiet = {
          pl1Watts = 25;
          pl2Watts = 40;
        };
        balanced = {
          pl1Watts = 55;
          pl2Watts = 80;
        };
        performance = {
          pl1Watts = 75;
          pl2Watts = 100;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    boot.kernelModules = [
      "intel_rapl_common"
      "intel_rapl_msr"
    ];

    systemd.services.rapl-power-limit = {
      description = "Sync Intel RAPL power limits with asusd events";
      wantedBy = [ "multi-user.target" ];
      after = [ "asusd.service" ];
      path = [
        pkgs.gnugrep
        pkgs.coreutils
      ];

      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "rapl-daemon" ''
          ${applyRaplScript}

          ${pkgs.dbus}/bin/dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',path='/xyz/ljones'" |
          while read -r line; do
            if echo "$line" | grep -q "PlatformProfile"; then
              ${applyRaplScript}
            fi
          done
        '';
        Restart = "always";
        RestartSec = "5s";
      };
    };

    systemd.services.rapl-power-limit-resume = {
      description = "Re-apply RAPL power limits after resume";
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = applyRaplScript;
      };
    };

  };
}
