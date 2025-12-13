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
        ./system
      ];

  options.custom-hm.user = {

    input = {

      repeat-delay = lib.mkOption {
        default = 660;
        type = lib.types.int;
      };

      repeat-rate = lib.mkOption {
        default = 25;
        type = lib.types.int;
      };

      xkb = {
        layout = lib.mkOption {
          default = "us";
          type = lib.types.str;
        };
        options = lib.mkOption {
          default = "";
          type = lib.types.str;
        };
      };

    };

  };

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
  #   # ./apps/swappy.nix
  #   # ./apps/vcv-rack.nix
  #   # ./apps/zathura.nix
  #   # ./apps/zen-browser.nix
  #
  # ];

}
