# NixOS configuration with dotfiles

NixOS configuration based on Hyprland compositor, utilizing catppuccin-macchiato color scheme (mainly for TUI apps).

## Apps & Utils

### Hardware

| Type       | App    |
| ---------- | ------ |
| CPU + iGPU | Intel  |
| dGPU       | Nvidia |

### Desktop Environment

#### Hyprland

| Type              | App               |
| ----------------- | ----------------- |
| Display manager   | tuigreet          |
| Compositor        | Hyprland          |
| Session Manager   | uwsm              |
| Wallpaper         | HyprPaper         |
| Bar, Notify, OSD  | HyprPanel         |
| Launcher          | Fuzzel            |
| Idle daemon       | Swayidle          |
| Lockscreen        | Swaylock          |
| Screenshots       | Hyprshot + Swappy |
| Clipboard manager | wl-clipboard      |

#### Gnome

| Type            | App   |
| --------------- | ----- |
| Display manager | gdm   |
| Everything else | Gnome |

### Terminal

| Type              | App                                                           |
| ----------------- | ------------------------------------------------------------- |
| Terminal emulator | Kitty                                                         |
| Shell             | Fish + Nushell                                                |
| Prompt            | Starship                                                      |
| Editor            | Neovim + [NixVim](https://github.com/atimofeev/nixvim-config) |
| File browser      | Yazi                                                          |
| Audio player      | spotify-player                                                |
| Process monitor   | btop                                                          |
| GPU monitor       | nvtop                                                         |

### GUI apps

| Type         | App         |
| ------------ | ----------- |
| Browser      | Firefox     |
| Video player | mpv         |
| Torrent      | qbittorrent |
| Music making | vcv-rack    |

### Services

| Type             | App                 |
| ---------------- | ------------------- |
| File sync        | Syncthing           |
| Homepage         | homepage-dashboard  |
| Key remapper     | xremap              |
| Local LLM        | Ollama + Open WebUI |
| Power management | auto-cpufreq        |
| Virtualization   | Docker              |

### Additional Features

| Type                 | App                                                   |
| -------------------- | ----------------------------------------------------- |
| Secret managemet     | [sops-nix](https://github.com/Mic92/sops-nix)         |
| Gaming optimizations | [nix-gaming](https://github.com/fufexan/nix-gaming)   |
| Flatpak              | [nix-flatpak](https://github.com/gmodena/nix-flatpak) |

## TODOs

### HW

- [ ] Fan control: fix nbfc
- [ ] Update Embedded Controller configuration of temp-based cooling rules. [1](https://4pda.to/forum/index.php?showtopic=843452&view=findpost&p=76102206)

### OS

- [ ] Low battery notifications (from upower)\
       Hyprpanel issue: [1](https://github.com/Jas-SinghFSU/HyprPanel/issues/341)
- [ ] Gaming
  - [ ] Emulators (retroarch, etc...)
  - [ ] NixOS specializations: pure iGPU & dGPU-offload

### DE

- [ ] Hyprland
  - [ ] Night Light with schedule (wlsunset, wl-gammarelay: [1](https://www.reddit.com/r/hyprland/comments/12qczxw/how_to_setup_blue_light_filter/), hyprsunset, gammastep, wl-gammarelay-rs)
- [ ] Clipboard manager: try something with interactive history (wl-clipboard + rofi?)
- [ ] Screen recorder: wf-recorder?
- [ ] Swaylock: fork & implement blur based on latest version (most swaylock-effects forks are not maintained)

### Apps

- [ ] k9s: remap system actions `cmd mode = ;`, `back = backspace/q`
- [ ] Firefox
  - [ ] Vim motions
    - [ ] [vimium](https://github.com/philc/vimium)
    - [ ] [tridactyl](https://github.com/tridactyl/tridactyl)
    - [ ] [Surgingkeys](https://github.com/brookhong/Surfingkeys)
    - [ ] [firenvim](https://github.com/glacambre/firenvim)
  - [ ] [Extensions example with NUR](https://github.com/chadcat7/crystal/blob/d412b11824f13e251186afec31714abda29e323c/home/namish/conf/browsers/firefox/default.nix)
  - [ ] [Userstyles](https://github.com/catppuccin/userstyles)
- [ ] Fish: preserve history `~/.local/share/fish/fish_history`
- [ ] VCV Rack 2: use config and patch repos
- [ ] mpv
  - [ ] try out [mpvScripts.simple-mpv-webui](https://github.com/open-dynaMIX/simple-mpv-webui) plugin
  - [ ] import [auto-save-state](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/auto-save-state.lua) script
  - [ ] import [select-subtitle](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/select-subtitle.lua) script
  - [ ] try out [mpv-manga-reader](https://github.com/Dudemanguy/mpv-manga-reader). Example: [1](https://github.com/azuwis/nix-config/blob/304360532bd517e5c8fff81a153e8c654f66a64c/common/mpv/manga-reader.nix#L24)
  - [ ] build custom script. Example: [1](https://github.com/DarkKronicle/nazarick/blob/ace0c35332dbab25bde4502e7d3dc64dc38c996d/modules/home/app/mpv/leader.nix#L9)
- [ ] Kitty: setup layouts. Example: [gh](https://github.com/search?q=enabled_layouts+path%3A**%2Fkitty.conf&type=code), [docs](https://sw.kovidgoyal.net/kitty/layouts/)

## Issues

- `Marshall Motiff II ANC` glitchy A2DP sink, sometimes becoming unavailable upon connection. Fixed with either pipewire restart or reboot\
  Issue somewhere in between `pipewire` and `bluez`\
  The solution? [1](https://github.com/bluez/bluez/issues/419)
- `xone` dongle does not enter pairing mode\
  Probably can be fixed by [overlay](https://github.com/search?q=repo%3Agiovannilucasmoura%2Fdotfiles%20xone&type=code) or patch including [pull request](https://github.com/medusalix/xone/pull/35) code
- `analog-input-internal-mic` had +30db gain on `Internal Mic Boost Volume`, alsa state config asset is not working\
  Probably can be fixed with pipewire/wireplumber config
