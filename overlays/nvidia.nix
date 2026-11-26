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
                  # Restore RTD3 on Linux 7.3: https://github.com/NVIDIA/open-gpu-kernel-modules/pull/1512
                  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/1507
                  ./patches/nvidia-rtd3-kthread-nullfs.patch
                  # Defer periodic firmware wakes.
                  # https://github.com/NVIDIA/open-gpu-kernel-modules/pull/1299
                  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/860
                  ./patches/nvidia-nvpcf-defer-notifications.patch
                ];
              });
            };
          });
        }
      );
    }
  );
}
