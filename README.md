# NixOS configuration with dotfiles

This is my fist attempt on NixOS config and currently it's a work in progress in a very early stage. A lot of changes are incoming.

## Apps & Features

List of current apps and features of this config.
Under active migration from my [dotfiles](https://github.com/atimofeev/dotfiles)

### Hardware

- [x] auto-cpufreq
- [ ] Nvidia support

### Desktop Environment

- [x] Gnome
- [ ] Hyprland

### Terminal

- [x] Kitty
- [x] Fish
- [x] Starship
- [x] Core utils
- [x] Improved & fun utils
- [ ] NeoVim

### Work

- [x] Ansible
- [x] Terraform
- [x] Docker
- [x] K8s: minikube, kubectl, helm, k9s

### Multimedia

- [x] mpv
- [x] spotify-player
- [ ] qbittorrent
- [ ] VCV Rack 2

## Issues

## Goals

- [ ] Hyprland DE config
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
  - [ ] Use [base16 Doom One colorscheme](https://github.com/MArpogaus/base16-doom/) ([Doom Emacs default theme](https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el)).
  - [ ] With [base16.nix](https://github.com/SenchoPens/base16.nix) or [stylix](https://github.com/danth/stylix) apply this theme across all applicable apps
    - [ ] Display manager
    - [ ] Hyprland window borders
    - [ ] Bar
    - [ ] Notifications
    - [ ] App runner
    - [ ] Widgets
    - [ ] Terminal
    - [ ] Editor
    - [ ] Shell prompt?
  - [ ] Switch to dynamically generated theme from a wallpaper
- [ ] NeoVim config
  - [ ] Create separate repo with current NvChad config
  - [ ] Create [NixVim](https://github.com/nix-community/nixvim) config from scratch
