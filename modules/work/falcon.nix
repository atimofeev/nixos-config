{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.crowdstrike-falcon;
  runtime = cfg.package.runtime;
  sensorDir = "${cfg.package}/opt/CrowdStrike";
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
      services.falcon-sensor = {
        after = [
          "sops-nix.service"
          "systemd-tmpfiles-setup.service"
        ];
        description = "CrowdStrike Falcon Sensor";
        environment.LD_LIBRARY_PATH = "${cfg.package.libraryPath}:/opt/CrowdStrike";
        path = [
          pkgs.coreutils
          pkgs.findutils
        ];
        preStart = ''
          set -euo pipefail
          umask 0077

          # Validate tmpfiles-created state before allowing falconctl to access it.
          while IFS= read -r -d $'\0' directory; do
            target="/opt/CrowdStrike''${directory#${sensorDir}}"
            if [[ -L "$target" ]]; then
              echo "Refusing a symlinked Falcon state directory: $target" >&2
              exit 1
            fi
            if [[ ! -d "$target" ]]; then
              echo "Missing Falcon state directory; check systemd-tmpfiles-setup: $target" >&2
              exit 1
            fi
          done < <(find ${sensorDir} -type d -print0)

          if ! protectionStatus="$(${cfg.package}/bin/falconctl -g --protection-status 2>/dev/null)"; then
            echo "Cannot determine Falcon maintenance protection; refusing to change installation." >&2
            exit 1
          fi

          while IFS= read -r -d $'\0' entry; do
            target="/opt/CrowdStrike/''${entry#${sensorDir}/}"
            if [[ -L "$target" && "$(readlink "$target")" == "$entry" ]]; then
              continue
            fi
            if [[ -e "$target" && ! -L "$target" ]]; then
              echo "Refusing to replace an unmanaged Falcon file: $target" >&2
              exit 1
            fi
            if [[ "$protectionStatus" == *"Armed=True"* ]]; then
              echo "Falcon maintenance protection is armed; refusing to change packaged files." >&2
              exit 1
            fi
            ln -sfnT "$entry" "$target"
          done < <(find ${sensorDir} \( -type f -o -type l \) -print0)

          cid="$(< "$CREDENTIALS_DIRECTORY/cid")"
          if [[ ! "$cid" =~ ^[[:xdigit:]]{32}-[[:xdigit:]]{2}$ ]]; then
            echo "Falcon CID credential must contain a customer ID with checksum." >&2
            exit 1
          fi
          # falconctl returns the UUID without the provisioning checksum.
          expectedCid="cid=\"''${cid%%-*}\"."
          if configuredCid="$(${cfg.package}/bin/falconctl -g --cid 2>/dev/null)"; then
            if [[ "''${configuredCid,,}" != "''${expectedCid,,}" ]]; then
              echo "Falcon is already enrolled with a different CID; refusing to re-enroll." >&2
              exit 1
            fi
          elif ! ${cfg.package}/bin/falconctl -s --cid="$cid" >/dev/null 2>&1; then
            echo "Falcon CID provisioning failed; check the credential and tenant requirements." >&2
            exit 1
          fi
        '';
        serviceConfig = {
          # Supply FHS paths without changing vendor ELF files or hiding host PID/network namespaces.
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
          Delegate = true;
          ExecStart = "${sensorDir}/falcond";
          KillMode = "control-group";
          KillSignal = "SIGTERM";
          LoadCredential = [ "cid:${cfg.cidFile}" ];
          PIDFile = "/run/falcond.pid";
          Restart = "no";
          TimeoutStopSec = "60s";
          Type = "forking";
          UMask = "0077";
        };
        unitConfig.RequiresMountsFor = [
          "/opt/CrowdStrike"
          "/var"
          cfg.cidFile
        ];
        wantedBy = [ "multi-user.target" ];
      };
      tmpfiles.rules = map (directory: "d ${directory} 0750 root root -") stateDirectories;
    };
  };
}
