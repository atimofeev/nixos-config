# NixOS configuration with dotfiles

NixOS configuration based on Hyprland compositor and it's ecosystem of apps, utilizing catppuccin-macchiato color theme.

## Apps & Utils

### Hardware

| Type             | App          |
| ---------------- | ------------ |
| CPU + iGPU       | Intel        |
| dGPU             | Nvidia       |
| Power management | auto-cpufreq |

### Desktop Environment

| Type              | App               |
| ----------------- | ----------------- |
| Display manager   | gdm               |
| Compositor        | Hyprland          |
| Wallpaper         | Hyprpaper         |
| Bar               | Hyprpanel         |
| Notifications     | Hyprpanel         |
| OSD               | Hyprpanel         |
| Launcher          | Hyprlauncher      |
| Idle daemon       | Hypridle          |
| Lockscreen        | Hyprlock          |
| Screenshots       | Hyprshot + Swappy |
| Clipboard manager | wl-clipboard      |

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

| Type           | App       |
| -------------- | --------- |
| Virtualization | Docker    |
| Key remapper   | xremap    |
| File sync      | Syncthing |

### Additional Features

| Type                 | App                                                   |
| -------------------- | ----------------------------------------------------- |
| Secret managemet     | [sops-nix](https://github.com/Mic92/sops-nix)         |
| Gaming optimizations | [nix-gaming](https://github.com/fufexan/nix-gaming)   |
| Flatpak              | [nix-flatpak](https://github.com/gmodena/nix-flatpak) |

## TODOs

### HW

- [ ] Fan control: fix nbfc
- [ ] GPU: Latest nvidia drivers
- [ ] Update Embedded Controller configuration of temp-based cooling rules. [1](https://4pda.to/forum/index.php?showtopic=843452&view=findpost&p=76102206)

### OS

- [ ] Display manager: sddm or ly?
- [ ] Gaming
  - [ ] Emulators (retroarch, etc...)
  - [ ] NixOS specializations: pure iGPU & dGPU-offload

### DE

- [ ] Hyprland
  - [ ] Cursors, icons & themes
    - [x] Hyprcursor
    - [x] GTK
    - [x] QT
    - [ ] App icons
  - [ ] Night Light with schedule (wlsunset, wl-gammarelay: [1](https://www.reddit.com/r/hyprland/comments/12qczxw/how_to_setup_blue_light_filter/), or hyprsunset)
- [ ] Launcher: rofi?
- [ ] Clipboard manager: try something with interactive history (wl-clipboard + rofi?)
- [ ] Screen recorder: wf-recorder?

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

- `hyprland`
  - Moving windows into active special workspace will break the current view
  - xwayland apps (e.g. slack) causes stutters & instability over time (nvidia + wayland issue?)
- `hyprlock`
  - Random RSODs on wake
  - No password prompt on manual lock
  - Random issues on wake after manual suspend (e.g. close lid)
- `xone` dongle does not enter pairing mode\
  Probably can be fixed by [overlay](https://github.com/search?q=repo%3Agiovannilucasmoura%2Fdotfiles%20xone&type=code) or patch including [pull request](https://github.com/medusalix/xone/pull/35) code
- `analog-input-internal-mic` had +30db gain on `Internal Mic Boost Volume`, alsa state config asset is not working\
  Probably can be fixed with pipewire/wireplumber config
