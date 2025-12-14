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
        ./apps
        ./options
        ./services
        ./system
      ];

}
