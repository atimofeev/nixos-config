# https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/xone/default.nix
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/xone.nix
# https://github.com/medusalix/xone/pull/45
{ pkgs, ... }:

# NOTE: no effect

# final: prev: {
#   xone = prev.xone.overrideAttrs (oldAttrs: {
#     src = pkgs.fetchFromGitHub {
#       owner = "medusalix";
#       repo = "xone";
#       # rev = "refs/pull/45/head";
#       rev = "3463d0e2335998c1b94bb1605dc7a6668d4ba262";
#       sha256 = "";
#     };
#   });
# }

# NOTE: no effect

# final: prev: {
#   linuxPackages = prev.linuxPackages.extend (lpself: lpsuper: {
#     # xone = lpsuper.xone.overrideAttrs (oldAttrs: {
#     xone = prev.xone.overrideAttrs (oldAttrs: {
#       src = pkgs.fetchFromGitHub {
#         owner = "medusalix";
#         repo = "xone";
#         rev = "3463d0e2335998c1b94bb1605dc7a6668d4ba262";
#         sha256 = "";
#       };
#     });
#   });
# }

# NOTE: no effect

# final: prev: {
#   linuxPackages = prev.linuxPackages.extend
#     (lpfinal: lpprev: { xone = lpfinal.callPackage ../pkgs/xone.nix; });
# }
