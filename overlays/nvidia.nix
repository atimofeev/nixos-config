# NVIDIA 615.71.09 backport
# nixpkgs#561660 adds 615.71.09 to nixos-unstable; this overlay backports it
# to the repo's pinned nixpkgs-unstable so zefir can select it before merge.
# objtool --hacks=jump_label workaround from open-gpu-kernel-modules#1095 is
# no longer needed: Linux 7.2 Kbuild already runs objtool with
# CONFIG_HAVE_JUMP_LABEL_HACK=y and CONFIG_OBJTOOL_WERROR unset, so
# unpatched open modules already contain NOPs at jump-label sites.

_: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (
    _: kprev: {
      nvidiaPackages = kprev.nvidiaPackages.extend (
        _: nprev: {
          new_feature = nprev.mkDriver {
            version = "615.71.09";
            sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
            sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
            openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
            settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
            persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
          };
        }
      );
    }
  );
}
