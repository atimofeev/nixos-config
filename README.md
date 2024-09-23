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
- [ ] Firefox -> Zen-browser?
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
  - [ ] Drop-down terminal [hdrop](https://github.com/hyprwm/contrib/blob/2d4ece4a008feefddc194bde785b1d39f987b5a7/hdrop/hdrop), [2](https://github.com/Schweber/hdrop)

### Apps

- [ ] k9s: remap system actions `cmd mode = ;`, `back = backspace/q`
- [ ] Firefox
  - [ ] Vim motions
    - [ ] [vimium](https://github.com/philc/vimium)
    - [ ] [tridactyl](https://github.com/tridactyl/tridactyl)
    - [ ] [Surgingkeys](https://github.com/brookhong/Surfingkeys)
    - [ ] [firenvim](https://github.com/glacambre/firenvim)
  - [x] Search engines with aliases
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
- `xremap` KBs to launch apps causes very weird behavior in Gnome with user mode
  Probably should wait until proper [nixos implementation](https://github.com/NixOS/nixpkgs/issues/234076) \
  Or move to Hyprland: [1](https://github.com/Maticzpl/nix-config/blob/1d84bb79d5e3f0e0b7996e914653c1cfc89e7844/nix-modules/hyprland/xremap.nix)
- `xone` dongle does not enter pairing mode\
  Probably can be fixed by [overlay](https://github.com/search?q=repo%3Agiovannilucasmoura%2Fdotfiles%20xone&type=code) or patch including [pull request](https://github.com/medusalix/xone/pull/35) code
- `analog-input-internal-mic` had +30db gain on `Internal Mic Boost Volume`, alsa state config asset is not working\
  Probably can be fixed with pipewire/wireplumber config
