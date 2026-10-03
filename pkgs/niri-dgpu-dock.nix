{
  coreutils,
  dgpuPath,
  fragmentPath,
  gnugrep,
  owner,
  writeShellApplication,
}:

writeShellApplication {
  name = "niri-dgpu-dock";

  runtimeInputs = [
    coreutils
    gnugrep
  ];

  text = ''
    dgpu=${dgpuPath}
    fragment=${fragmentPath}
    owner=${owner}

    dgpu_card() {
      local target
      target="$(readlink -f "$dgpu" 2>/dev/null)" || return 1
      [ -n "$target" ] || return 1
      basename "$target"
    }

    # Any connector of the dGPU reporting "connected" (e.g. hot-plugged DP/USB-C monitor).
    dgpu_output_connected() {
      local card="$1" status
      for status in /sys/class/drm/"$card"-*/status; do
        [ -e "$status" ] || continue
        if [ "$(cat "$status")" = "connected" ]; then
          return 0
        fi
      done
      return 1
    }

    write_fragment() {
      local content="$1"
      mkdir -p "$(dirname "$fragment")"
      printf '%s\n' "$content" > "$fragment"
      chown "$owner:" "$fragment" 2>/dev/null || true
      chmod 0644 "$fragment"
    }

    bind_dgpu() {
      write_fragment "// niri-dgpu-dock: dGPU bound, external output attached"
    }

    ignore_dgpu() {
      write_fragment "debug {
      ignore-drm-device \"$dgpu\"
    }"
    }

    reload_niri() {
      # When invoked from the user session, niri is reachable; from udev/root the
      # include watcher picks the fragment up on its own.
      [ -n "''${XDG_RUNTIME_DIR:-}" ] || return 0
      [ -n "''${WAYLAND_DISPLAY:-}" ] || return 0
      command -v niri >/dev/null 2>&1 || return 0
      niri msg action load-config-file >/dev/null 2>&1 || true
    }

    mode="''${1:-auto}"
    card="$(dgpu_card)" || exit 0

    case "$mode" in
      on) bind_dgpu ;;
      off) ignore_dgpu ;;
      toggle)
        if grep -q 'ignore-drm-device' "$fragment" 2>/dev/null; then
          bind_dgpu
        else
          ignore_dgpu
        fi
        ;;
      auto)
        if dgpu_output_connected "$card"; then
          bind_dgpu
        else
          ignore_dgpu
        fi
        ;;
      *)
        echo "usage: niri-dgpu-dock [auto|on|off|toggle]" >&2
        exit 2
        ;;
    esac

    reload_niri
  '';
}
