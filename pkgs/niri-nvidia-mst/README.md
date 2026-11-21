# Niri NVIDIA MST workaround

Enabled on zefir by `custom.desktop.niri.nvidiaMstWorkaround`. The Home Manager
module starts a session-scoped user service and includes a writable
`~/.config/niri/nvidia-mst.kdl`. The existing dGPU binding/power helper is separate. Both policies reuse the event
subscriptions and atomic-file/process helpers in `pkgs/niri-session/`.
Hosts without the option retain the previous static debug setting.

## Detection

The probe is compiled from the selected NVIDIA package's open-module source and
patches. It refuses a different loaded driver version, including after switching
to a new system generation before rebooting into its driver.

The watcher resolves `/dev/dri/dgpu` through sysfs. With no connected external
connector it returns inactive without opening NVIDIA. Otherwise the C probe maps
the GPU's PCI address to its RM device instance and briefly opens an NVKMS client.
It queries dynamic display IDs, `isDpMST` and the assigned head. Retained MST
objects with invalid heads do not count. No display ownership, modesets, EDID
changes or console-hotplug handling are requested.

Probe exit codes: 0 = active MST, 1 = inactive, 2 = unknown. Errors or incomplete
detection preserve the previous fragment. The initial fragment enables the
workaround conservatively until the first successful check. An enabled fragment
contains:

```kdl
debug {
    wait-for-frame-completion-before-queueing
}
```

This detects NVIDIA MST, not USB-C specifically. It also applies to a single
active sink behind an MST branch and does not depend on monitor/dock identities.

## Events and updates

The service listens for DRM uevents, logind suspend/resume, Niri workspace events
that change the set of active outputs, and SIGUSR1. Workspace-only changes are
ignored. Hotplug bursts are debounced, with at most three settling attempts
(0.5, 1 and 2 seconds between attempts); disabling waits for the last attempt.
Niri output events cover delayed compositor attachment and enabling a previously
disabled output after that window. No periodic GPU polling or persistent NVKMS
handle is used. Loss of an event stream causes systemd to restart the service.

The fragment is atomically replaced only when its content changes, followed by
an explicit Niri reload. The first successful startup check also reloads once,
recovering a previous process that exited between writing and reloading.
Reload failures are retried during the settling window.
NVIDIA may emit its existing DPCD warnings while allocating the temporary client.

The Niri configuration generator needs repeated `{ _args = [ "file.kdl" ]; }`
include nodes: a plain list of strings becomes one invalid multi-argument include.

## Operations

After rebuilding/activating the NixOS configuration:

```bash
systemctl --user status niri-nvidia-mst
journalctl --user -u niri-nvidia-mst -b
niri-nvidia-mst status
systemctl --user reload niri-nvidia-mst   # request a fresh check
```

`status` is read-only; it exits nonzero on detection failure. `update` is a one-shot
writer for troubleshooting while the service is stopped. A file lock prevents
concurrent writers. Do not run a second watcher against the same fragment.

## Verification

Package builds run the Python state-machine tests without accessing real devices:

```bash
PYTHONPATH=pkgs/niri-session python -B -m unittest discover -s pkgs/niri-nvidia-mst -v
```

Also validate the actual generated Niri configuration with both fragment states
and both dGPU binding states; upstream Nix generation alone strips includes from
its validation. Runtime acceptance after activation includes dock unplug/replug,
one MST sink, a direct non-MST monitor, login, suspend/resume and GPU runtime
suspend without external monitors. The configuration switch itself is not part
of the package tests.

NVKMS ABI reference: NVIDIA/open-gpu-kernel-modules,
`src/nvidia-modeset/interface/nvkms-api.h`. Follow the version selected by Nix,
not an independently pinned header or a copied struct layout.
