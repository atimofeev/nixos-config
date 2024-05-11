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
  - [ ] [Userstyles](https://github.com/catppuccin/userstyles)
  - [ ] [Vim motions](https://github.com/tridactyl/tridactyl)
- [ ] Gnome: Tiling [1](https://github.com/material-shell/material-shell) ([itsfoss](https://itsfoss.com/material-shell/)), [2](https://github.com/forge-ext/forge)
- [ ] Fish: preserve history `~/.local/share/fish/fish_history`
- [ ] VCV Rack 2: use config and patch repos
- [ ] mpv
  - [ ] try out `simple-mpv-ui` plugin
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

- `bluetooth` BLE headset device only works in handsfree mode after auto reconnect
- `2.4 wireless mouse` on boot won't work properly unless dongle is reconnected\
  Not reproducible with clean Nix Gnome setup
- `xone` won't work with Xbox wireless dongle. [nixpkgs issue](https://github.com/NixOS/nixpkgs/issues/308028)
- `Firefox` conflicting config between home-manager and firefox profile sync.\
  Custom search engines config breaks search aliases
- `k9s` aliases and plugins config is broken
- `xremap` not working with DE for app shortcuts\
  Probably should wait until proper [nixos implementation](https://github.com/NixOS/nixpkgs/issues/234076)\
  Or use [gnomeExtensions.xremap](https://search.nixos.org/packages?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=xremap)? [gh link](https://github.com/xremap/xremap-gnome)
- `Mi Notebook Pro integrated mic` had +30db gain, alsa state config asset is not working

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
