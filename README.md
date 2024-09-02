# NixOS configuration with dotfiles

NixOS configuration with Gnome DE, utilizing catppuccin-macchiato color theme for most apps.

## Apps & Features

List of configured apps and features of this config.

### Hardware

- [ ] auto-cpufreq -> tlp
- [x] Nvidia support

### Desktop Environment

- [x] Gnome
- [ ] Hyprland (currently abandoned)

### Terminal

- [x] Kitty
- [x] Fish
- [x] Starship
- [x] Core & misc utils

### GUI/TUI Apps

- [x] NeoVim (i also use [NixVim](https://github.com/atimofeev/nixvim-config) btw)
- [ ] Firefox -> Zen-browser
- [x] mpv
- [x] spotify-player
- [x] qbittorrent
- [ ] VCV Rack 2
- [x] k9s

### Work

- [x] Ansible
- [x] OpenTofu
- [ ] Docker -> Podman
- [x] Kubernetes
- [x] GNS3
- [x] VM utils

## TODOs

### OS

- [ ] Gaming
  - [ ] gamemode
  - [ ] gamescope
  - [ ] Emulators (retroarch, etc...)
  - [ ] [nix-gaming](https://github.com/fufexan/nix-gaming) to use steam platformOptimizations
  - [ ] Launch options: pure iGPU & dGPU-offload
- [ ] Update Embedded Controller configuration of temp-based cooling rules. [1](https://4pda.to/forum/index.php?showtopic=843452&view=findpost&p=76102206)

### Desktop

- [ ] Gnome
  - Tiling:
    - [x] [gnomeExtensions.pop-shell](https://github.com/pop-os/shell)
    - [ ] [gnomeExtensions.forge](https://github.com/forge-ext/forge)
    - [ ] [gnomeExtensions.paperwm](https://github.com/paperwm/PaperWM)
    - [ ] [gnomeExtensions.material-shell](https://github.com/material-shell/material-shell)
  - Misc:
    - [x] Default terminal: kitty. [example](https://github.com/Konecho/nixos-config/blob/b1caefe45c071aad97726ab0d0f87895ef455a9e/system/desktop/gnome.nix#L45)
    - [ ] Remove unused apps. [example](https://github.com/Konecho/nixos-config/blob/b1caefe45c071aad97726ab0d0f87895ef455a9e/system/desktop/gnome.nix#L11)
    - [ ] Drop-down terminal extension: [gnomeExtensions.drop-down-terminal](https://github.com/zzrough/gs-extensions-drop-down-terminal) or [gnomeExtensions.quake-terminal](https://github.com/diegodario88/quake-terminal) or [gnomeExtensions.quake-mode](https://github.com/repsac-by/gnome-shell-extension-quake-mode)
    - [ ] Configure file associations. Example: [1](https://github.com/zoriya/flake/blob/cc58c927b06f687ad524770371a9ac28edb4ea15/modules/common/apps.nix)
- [ ] Hyprland
  - [x] Hotkeys
  - [x] Window rules
  - [ ] Clipboard manager
  - [ ] Nvidia support
  - [ ] Display manager (sddm)
  - [ ] Bar, notifications and widgets (ags)
  - [ ] App runner (rofi-wayland)
  - [ ] Hardware control (brightness, volume, bluetooth, wireless, camera)
  - [ ] Wallpaper tool (hyprpaper)
  - [ ] Screenshot tool
  - [ ] Drop-down terminal (?) [hdrop](https://github.com/hyprwm/contrib/blob/2d4ece4a008feefddc194bde785b1d39f987b5a7/hdrop/hdrop)

### Apps

- [ ] k9s: remap system actions `cmd mode = ;`, `back = backspace/q`
- [ ] Firefox
  - [ ] Vim motions
    - [ ] [vimium](https://github.com/philc/vimium)
    - [ ] [tridactyl](https://github.com/tridactyl/tridactyl)
    - [ ] [Surgingkeys](https://github.com/brookhong/Surfingkeys)
    - [ ] [firenvim](https://github.com/glacambre/firenvim)
  - [ ] Search engines with aliases
  - [ ] Themes: [1](https://addons.mozilla.org/en-US/firefox/addon/catppuccin-macchiato-lavender2) or [2](https://github.com/catppuccin/firefox)
  - [ ] [Extensions example with NUR](https://github.com/chadcat7/crystal/blob/d412b11824f13e251186afec31714abda29e323c/home/namish/conf/browsers/firefox/default.nix)
  - [ ] [Userstyles](https://github.com/catppuccin/userstyles)
- [ ] Fish: preserve history `~/.local/share/fish/fish_history`
- [ ] VCV Rack 2: use config and patch repos
- [ ] mpv
  - [ ] try out [mpvScripts.simple-mpv-webui](https://github.com/open-dynaMIX/simple-mpv-webui) plugin
  - [ ] import [auto-save-state](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/auto-save-state.lua) script
  - [ ] import [select-subtitle](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/select-subtitle.lua) script
- [ ] Kitty: setup layouts. [gh examples](https://github.com/search?q=enabled_layouts+path%3A**%2Fkitty.conf&type=code), [docs](https://sw.kovidgoyal.net/kitty/layouts/)
- [ ] Terminal FM: `yazi` or `lf`

## Issues

- `2.4 wireless mouse` on boot won't work properly unless dongle is reconnected\
  Not reproducible with clean Nix Gnome setup
- `Firefox`
  - Conflicting config between home-manager and firefox profile sync.\
    Custom search engines config breaks search aliases
  - HEVC video playback on github is broken. [example](https://github.com/mrjones2014/smart-splits.nvim/issues/179#issuecomment-2049847490)
- `ungoogled-chromium` try out. Config examples: [1](https://github.com/berbiche/dotfiles/blob/1e4d0501bde814be76419d8f21cf2fb9079e6a93/profiles/programs/chromium.nix#L49), [2](https://github.com/corytertel/nix-configuration/blob/15c5acf13669ef26e697cba514258c8c098aaf98/overlays/ungoogled-chromium.nix#L4), [3](https://github.com/pokon548/OysterOS/blob/31f46814e655da2cf4df53fd8f02a764fc7960fa/desktop/application/ungoogled-chromium/default.nix#L7), [4](https://github.com/kalbasit/soxincfg/blob/b600fb23f8611158e54b0cee85790b927ee2d89c/modules/programs/chromium/nixos.nix#L16)
- `xremap` KBs to launch apps causes very weird behavior in Gnome with user mode
  Probably should wait until proper [nixos implementation](https://github.com/NixOS/nixpkgs/issues/234076) \
  Or move to Hyprland: [1](https://github.com/Maticzpl/nix-config/blob/1d84bb79d5e3f0e0b7996e914653c1cfc89e7844/nix-modules/hyprland/xremap.nix)
- `xone` dongle does not enter pairing mode\
  Probably can be fixed by [overlay](https://github.com/search?q=repo%3Agiovannilucasmoura%2Fdotfiles%20xone&type=code) or patch including [pull request](https://github.com/medusalix/xone/pull/35) code
- `bluetooth` BLE headset device sometimes works only in handsfree mode after auto reconnect. Need service restart
  Possible solutions: [1](https://github.com/Snektron/nixos-config/blob/5f3fb5c29c28e2059e9a4d55994dd7217187792c/hosts/common/desktop.nix#L56), [2](https://github.com/DarkKronicle/nazarick/blob/438197f8a33f6bf4a78a1a946b31723ad4f86134/modules/nixos/system/bluetooth/default.nix#L17C5-L17C16), [3](https://discussion.fedoraproject.org/t/issue-with-fedora-38-and-bluetooth-headset-missing-headset-mode-after-reboot-only-handsfree-mode-shows-up/85896/4), [4](https://github.com/bluez/bluez/issues/752)\
   dmesg: `[289876.436013] Bluetooth: hci0: corrupted SCO packet` \
  `journalctl -u bluetooth -f`:

  ```console
  Aug 31 19:50:55 milaptop bluetoothd[924]: profiles/audio/avdtp.c:session_cb() No pending request, ignoring message
  Aug 31 19:51:01 milaptop bluetoothd[924]: src/service.c:btd_service_connect() a2dp-sink profile connect failed for 00:25:D1:37:8C:19: Device or resource busy
  ```

- `analog-input-internal-mic` had +30db gain on `Internal Mic Boost Volume`, alsa state config asset is not working\
  Probably can be fixed with pipewire/wireplumber config

## Notes

### Secrets

- Generate private age key from SSH key:\
  `nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt`
- Generate public key:\
  `nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt`
- Create `.sops.yaml` file:\

```yaml
keys:
  - &primary { { PUBLIC_KEY_HERE } }
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
      - age:
          - *primary
```

- Run `sops path_to_secrets/secrets.yaml` and add your secrets

### Useful code examples

https://nix.dev/guides/best-practices

- `with`

```nix
  environment.systemPackages = (with pkgs; [
    python3
    #go
    #rust
  ]) ++ (with pkgs-unstable;
    [
      yamlfix
    ]);
```

- `builtins.map`

```nix
sudo = {
  enable = true;
  extraRules = [
    {
      commands =
        builtins.map (command: {
          command = "/run/current-system/sw/bin/${command}";
          options = ["NOPASSWD"];
        })
        ["poweroff" "reboot" "nixos-rebuild" "nix-env" "bandwhich" "mic-light-on" "mic-light-off" "systemctl"];
      groups = ["wheel"];
    }
  ];
};
```

- Override module (options) channel

```nix
  imports = [
    (nixpkgs-unstable + "/nixos/modules/services/misc/homepage-dashboard.nix")
  ];

  disabledModules = [ "services/misc/homepage-dashboard.nix" ];

  nixpkgs.config = {
    packageOverrides = pkgs: { inherit (pkgs-unstable) homepage-dashboard; };
  };
```

- Override Go app: [1](https://discourse.nixos.org/t/inconsistent-vendoring-in-buildgomodule-when-overriding-source/9225/6), [2](https://github.com/NixOS/nixpkgs/issues/86349#issuecomment-945210042)

### Nix commands

- Update flake input: `nix flake lock --update-input nixpkgs-unstable --update-input 123`
