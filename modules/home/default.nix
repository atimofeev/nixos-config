{ lib, ... }:
{

  imports =
    lib.concatMap
      (
        dir:
        lib.pipe (builtins.readDir dir) [
          (lib.filterAttrs (path: _kind: !lib.hasPrefix "_" path))
          (lib.filterAttrs (
            _path: kind: kind == "directory" || (kind == "regular" && lib.hasSuffix ".nix" _path)
          ))
          (lib.mapAttrsToList (path: _kind: lib.path.append dir path))
        ]
      )
      [
        ./services
      ];

  # imports = [
  #
  #   # ./system/catppuccin.nix
  #   # ./system/nix-index.nix
  #   # ./system/sops.nix
  #
  #   ./services/cliphist.nix
  #   ./services/polkit-gnome.nix
  #   ./services/syncthing.nix
  #
  #   # ./apps/firefox
  #   # ./apps/terminal
  #   # ./apps/mpv.nix
  #   # ./apps/obsidian.nix
  #   # ./apps/qbittorrent.nix
  #   # ./apps/slack.nix
  #   # ./apps/swappy.nix
  #   # ./apps/vcv-rack.nix
  #   # ./apps/zathura.nix
  #   # ./apps/zen-browser.nix
  #
  # ];

}
