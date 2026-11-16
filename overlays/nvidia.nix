_: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (
    _: kprev: {
      nvidiaPackages = kprev.nvidiaPackages.extend (
        _: nprev: {
          new_feature = nprev.new_feature.overrideAttrs (old: {
            passthru = old.passthru // {
              open = old.passthru.open.overrideAttrs (oldOpen: {
                patches = (oldOpen.patches or [ ]) ++ [
                  # Fix display freezes: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/1289#issuecomment-6511752945
                  ./patches/nvidia-nvkms-alloc-device-before-lut-surfaces.patch
                ];
              });
            };
          });
        }
      );
    }
  );
}
