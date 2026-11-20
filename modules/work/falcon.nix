{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.crowdstrike-falcon;
  runtime = cfg.package.runtime;
  sensorDir = "${cfg.package.payload}";
  commonService = {
    after = [
      "sops-nix.service"
      "systemd-tmpfiles-setup.service"
    ];
    environment.LD_LIBRARY_PATH = "${cfg.package.libraryPath}:/opt/CrowdStrike";
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig = {
      # Supply FHS paths without modifying vendor ELF files or hiding the host.
      BindReadOnlyPaths = [
        "${runtime}/bin:/bin"
        "${runtime}/bin:/sbin"
        "${runtime}/bin:/usr/bin"
        "${runtime}/bin:/usr/sbin"
        "${runtime}/lib:/lib"
        "${runtime}/lib:/lib64"
        "${runtime}/lib:/usr/lib"
        "${runtime}/lib:/usr/lib64"
      ];
      LoadCredential = [ "cid:${cfg.cidFile}" ];
      UMask = "0077";
    };
    unitConfig.RequiresMountsFor = [
      "/opt/CrowdStrike"
      "/var"
      cfg.cidFile
    ];
  };
  inspectInstallation = ''
    set -euo pipefail
    umask 0077

    fail() {
      echo "$1" >&2
      exit 1
    }

    # Validate tmpfiles-created state before allowing falconctl to access it.
    while IFS= read -r -d $'\0' directory; do
      target="/opt/CrowdStrike''${directory#${sensorDir}}"
      [[ ! -L "$target" ]] || fail "Refusing a symlinked Falcon state directory: $target"
      [[ -d "$target" ]] || fail "Missing Falcon state directory; check systemd-tmpfiles-setup: $target"
    done < <(find ${sensorDir} -type d -print0)

    entriesToLink=()
    while IFS= read -r -d $'\0' entry; do
      target="/opt/CrowdStrike/''${entry#${sensorDir}/}"
      if [[ -L "$target" && "$(readlink "$target")" == "$entry" ]]; then
        continue
      fi
      [[ ! -e "$target" || -L "$target" ]] || fail "Refusing an unmanaged Falcon file: $target"
      entriesToLink+=("$entry")
    done < <(find ${sensorDir} \( -type f -o -type l \) -print0)

    cid="$(< "$CREDENTIALS_DIRECTORY/cid")"
    [[ "$cid" =~ ^[[:xdigit:]]{32}-[[:xdigit:]]{2}$ ]] ||
      fail "Falcon CID credential must contain a customer ID with checksum."
    # falconctl returns the UUID without the provisioning checksum.
    expectedCid="cid=\"''${cid%%-*}\"."
    provisionCid=false
    if configuredCid="$(${cfg.package}/bin/falconctl -g --cid 2>/dev/null)"; then
      [[ "''${configuredCid,,}" == "''${expectedCid,,}" ]] ||
        fail "Falcon is already enrolled with a different CID; refusing to re-enroll."
    else
      provisionCid=true
    fi
  '';
  stateDirectories = [
    "/opt/CrowdStrike"
    "/opt/CrowdStrike/ASPM"
    "/opt/CrowdStrike/ASPM/bin"
    "/opt/CrowdStrike/ASPM/results"
    "/opt/CrowdStrike/ASPM/tmp"
    "/opt/CrowdStrike/Falcon4IT"
    "/opt/CrowdStrike/Falcon4IT/bin"
    "/opt/CrowdStrike/Falcon4IT/results"
    "/opt/CrowdStrike/Packages"
    "/opt/CrowdStrike/config"
  ];
in
{
  options.custom.work.crowdstrike-falcon = {
    enable = lib.mkEnableOption "CrowdStrike Falcon Sensor";
    cidFile = lib.mkOption {
      type = lib.types.str;
      example = "/run/secrets/falcon-cid";
      description = "Absolute runtime path to the customer ID with checksum; never a Nix store path.";
    };
    package = lib.mkPackageOption pkgs "falcon" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasPrefix "/" cfg.cidFile && !lib.hasPrefix "/nix/store/" cfg.cidFile;
        message = "Falcon cidFile must be an absolute runtime path outside the Nix store.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    services.logrotate.settings.falcon-sensor = {
      daily = true;
      files = [ "/var/log/falcon-sensor.log" ];
      missingok = true;
      postrotate = "${pkgs.procps}/bin/pkill -HUP -x falcon-sensor || true";
      rotate = 7;
      sharedscripts = true;
    };

    system.extraDependencies = [ cfg.package.src ];

    systemd = {
      services = {
        falcon-sensor = commonService // {
          description = "CrowdStrike Falcon Sensor";
          preStart = inspectInstallation + ''
            if (( ''${#entriesToLink[@]} > 0 )); then
              entry="''${entriesToLink[0]}"
              target="/opt/CrowdStrike/''${entry#${sensorDir}/}"
              fail "Falcon installation link is missing or outdated: $target. Run falcon-sensor-setup.service explicitly; startup does not modify installation links."
            fi
            [[ "$provisionCid" == false ]] ||
              fail "Cannot verify Falcon enrollment. Run falcon-sensor-setup.service explicitly for initial enrollment."
          '';
          serviceConfig = commonService.serviceConfig // {
            Delegate = true;
            ExecStart = "${sensorDir}/falcond";
            KillMode = "control-group";
            KillSignal = "SIGTERM";
            PIDFile = "/run/falcond.pid";
            Restart = "no";
            TimeoutStopSec = "60s";
            Type = "forking";
          };
          wantedBy = [ "multi-user.target" ];
        };
        # Deliberately not wanted/required by startup or activation.
        falcon-sensor-setup = commonService // {
          before = [ "falcon-sensor.service" ];
          description = "Explicit CrowdStrike Falcon installation and enrollment";
          restartIfChanged = false;
          preStart = ''
            case "$(systemctl show --property=ActiveState --value falcon-sensor.service)" in
              inactive|failed) ;;
              *)
                echo "Stop falcon-sensor.service before running Falcon setup." >&2
                exit 1
                ;;
            esac
          '';
          script = inspectInstallation + ''
            if (( ''${#entriesToLink[@]} == 0 )) && [[ "$provisionCid" == false ]]; then
              exit 0
            fi

            for entry in "''${entriesToLink[@]}"; do
              target="/opt/CrowdStrike/''${entry#${sensorDir}/}"
              ln -sfnT "$entry" "$target"
            done
            if [[ "$provisionCid" == true ]]; then
              ${cfg.package}/bin/falconctl -s --cid="$cid" >/dev/null 2>&1 ||
                fail "Falcon CID provisioning failed; check the credential and tenant requirements."
            fi
          '';
          serviceConfig = commonService.serviceConfig // {
            Type = "oneshot";
          };
        };
      };
      tmpfiles.rules = map (directory: "d ${directory} 0750 root root -") stateDirectories;
    };
  };
}
