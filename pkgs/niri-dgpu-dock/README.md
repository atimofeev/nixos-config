# Automatic Niri dGPU power saving

Enable the session service with `custom.desktop.niri.dgpuDock = true`.
There are no manual modes, overrides or keyboard shortcuts.

| Laptop power | dGPU display connected | GPU-ignore workaround |
| --- | --- | --- |
| AC | Either | inactive |
| Battery | Yes | inactive |
| Battery | No | active |

`active` means the GPU-ignore workaround is needed, not that the GPU is powered
on. As with `niri-nvidia-mst status`, status evaluates the current automatic
conditions rather than reading a potentially stale configuration fragment:

```bash
niri-dgpu-dock status     # active or inactive
systemctl --user status niri-dgpu-dock
systemctl --user reload niri-dgpu-dock  # recheck current conditions
journalctl --user -u niri-dgpu-dock -b
```

Power and connector state are read from sysfs without opening GPU device nodes.
Only system power supplies/batteries count; peripheral batteries and USB source
ports with `scope=Device` are ignored. Unknown power or connector information
preserves the current fragment rather than hiding a possibly needed GPU.

The service reacts to DRM and power-supply uevents, Niri output-set changes and
logind resume. It debounces event bursts, retries briefly while things settle,
and does not poll the GPU. Connecting AC or a display makes the GPU available;
ignoring the GPU waits until the settling window ends.

The Home Manager module owns the writable `dgpu-dock.kdl` fragment, initialization
and user service. GPU ordering only supplies the stable `/dev/dri/dgpu` identity
for this feature. The MST workaround remains an independent policy; the two
services reuse event/file/process utilities under `pkgs/niri-session/`.

Initialization preserves an existing fragment, removes obsolete `.mode` state,
and conservatively leaves the GPU available if first-start detection is unknown.
A lifetime lock prevents a second writer. Fragment updates are atomic; Niri is
reloaded on changes and once after a successful startup check. `update` is a
one-shot automatic update for troubleshooting while the service is stopped;
`init` and `watch` are used by activation and the service. The old `auto`, `on`,
`off` and `toggle` commands are no longer accepted.

## Verification

```bash
PYTHONPATH=pkgs/niri-session python -B -m unittest discover -s pkgs/niri-dgpu-dock -v
PYTHONPATH=pkgs/niri-session python -B -m unittest discover -s pkgs/niri-nvidia-mst -v
```

Builds run the unit tests. Validate both states of each runtime fragment against
the generated Niri config. After activation, test AC unplug/replug, display
unplug/replug, suspend/resume and runtime suspend on battery without external
displays. Hardware that cannot report hotplug while deeply suspended may still
need a compositor/device refresh; no manual policy override is provided.
