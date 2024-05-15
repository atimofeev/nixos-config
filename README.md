# NixOS configuration with dotfiles

This is my fist attempt on NixOS config and currently it's a work in progress in a very early stage.\
A lot of changes are coming.

## Apps & Features

List of current apps and features of this config.
Under active migration from my [dotfiles](https://github.com/atimofeev/dotfiles)

### Hardware

- [x] auto-cpufreq
- [x] Nvidia support

### Desktop Environment

- [x] Gnome
- [ ] Hyprland (currently abandoned)

### Terminal

- [x] Kitty
- [x] Fish
- [x] Starship
- [x] Core utils
- [x] Improved & fun utils
- [ ] NeoVim

### Apps

- [ ] Firefox
- [x] mpv
- [x] spotify-player
- [x] qbittorrent
- [ ] VCV Rack 2

### Work

- [x] Ansible
- [x] Terraform
- [x] Docker
- [x] K8s: minikube, kubectl, helm, k9s

## TODOs

### OS

- [ ] nix-sops with AES256 for secret management
- [ ] Gaming
  - [ ] gamemode
  - [ ] gamescope
  - [ ] Emulators (retroarch, etc...)
  - [ ] [nix-gaming](https://github.com/fufexan/nix-gaming) to use steam platformOptimizations
  - [ ] Launch options: pure iGPU & dGPU-offload
- [x] Xremap: Caps Lock + hjkl -> arrows
- [ ] auto-cpufreq -> tlp

### Apps

- [ ] NeoVim
  - [ ] [NixVim](https://github.com/atimofeev/nixvim-config) config
  - [ ] Minimal config via home-manager
- [ ] k9s: remap system actions `cmd mode = ;`, `back = backspace/q`
- [ ] Firefox
  - [ ] Search engines with aliases
  - [ ] [Theme](https://addons.mozilla.org/en-US/firefox/addon/catppuccin-macchiato-lavender2) or [this](https://github.com/catppuccin/firefox)
  - [ ] [Extensions example with NUR](https://github.com/chadcat7/crystal/blob/d412b11824f13e251186afec31714abda29e323c/home/namish/conf/browsers/firefox/default.nix)
  - [ ] [Userstyles](https://github.com/catppuccin/userstyles)
  - [ ] [Vim motions](https://github.com/tridactyl/tridactyl)
- [ ] Gnome Tiling
  - [ ] [gnomeExtensions.pop-shell](https://github.com/pop-os/shell)
  - [ ] [gnomeExtensions.forge](https://github.com/forge-ext/forge)
  - [ ] [gnomeExtensions.paperwm](https://github.com/paperwm/PaperWM)
  - [ ] [gnomeExtensions.material-shell](https://github.com/material-shell/material-shell)
- [ ] nautilus-open-any-terminal (nix unstable option): use kitty
- [ ] Fish: preserve history `~/.local/share/fish/fish_history`
- [ ] VCV Rack 2: use config and patch repos
- [ ] mpv
  - [ ] try out [mpvScripts.simple-mpv-webui](https://github.com/open-dynaMIX/simple-mpv-webui) plugin
  - [ ] import [auto-save-state](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/auto-save-state.lua) script
  - [ ] import [select-subtitle](https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/select-subtitle.lua) script
- [ ] Hyprland
  - [x] Hotkeys
  - [x] Window rules
  - [ ] Clipboard
  - [ ] Nvidia support
  - [ ] Display manager (sddm)
  - [ ] Bar (waybar or ags)
  - [ ] Notifications (dunst or ags)
  - [ ] App runner (rofi-wayland)
  - [ ] Hardware control (brightness, volume, bluetooth, wireless, camera)
  - [ ] Wallpaper tool (random wallpapers from directory)
  - [ ] Screenshot tool

## Issues

- `2.4 wireless mouse` on boot won't work properly unless dongle is reconnected\
  Not reproducible with clean Nix Gnome setup
- `Firefox`
  - Conflicting config between home-manager and firefox profile sync.\
    Custom search engines config breaks search aliases
  - HEVC video playback on github is broken. [example](https://github.com/mrjones2014/smart-splits.nvim/issues/179#issuecomment-2049847490)
- `k9s` aliases and plugins config is broken
- `xremap` KBs to launch apps causes very weird behavior in Gnome with user mode
  Probably should wait until proper [nixos implementation](https://github.com/NixOS/nixpkgs/issues/234076)
- `xone` dongle does not enter pairing mode\
  Probably can be fixed by [overlay](https://github.com/search?q=repo%3Agiovannilucasmoura%2Fdotfiles%20xone&type=code) or patch including [pull request](https://github.com/medusalix/xone/pull/35) code
- `bluetooth` BLE headset device only works in handsfree mode after auto reconnect
  Possible solutions: [1](https://github.com/Snektron/nixos-config/blob/5f3fb5c29c28e2059e9a4d55994dd7217187792c/hosts/common/desktop.nix#L56), [2](https://github.com/DarkKronicle/nazarick/blob/438197f8a33f6bf4a78a1a946b31723ad4f86134/modules/nixos/system/bluetooth/default.nix#L17C5-L17C16)
- `Mi Notebook Pro integrated mic` had +30db gain, alsa state config asset is not working\
  Turn it off completely?\
  Or fix and use as a replacement for handsfree mode?

## Notes

### Useful code examples

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
