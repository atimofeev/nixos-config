# ponytail: hotfix NVIDIA/open-gpu-kernel-modules#1095 — suspend needs objtool
# --hacks=jump_label on nvidia.ko/nvidia-modeset.ko after build.
# Remove when fix lands upstream in nixpkgs or NVIDIA driver.

_final: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (kfinal: kprev: {
    nvidiaPackages = kprev.nvidiaPackages.extend (nfinal: nprev: {
      stable = nprev.stable.overrideAttrs (oldAttrs: {
        passthru = (oldAttrs.passthru or { }) // {
          open = oldAttrs.passthru.open.overrideAttrs (openOld: {
            postBuild =
              (openOld.postBuild or "")
              + ''
                objtool="${
                  kfinal.kernel.dev
                }/lib/modules/${
                  kfinal.kernel.modDirVersion
                }/build/tools/objtool/objtool"
                find . -name nvidia.ko -exec $objtool --hacks=jump_label --module --link {} \;
                find . -name nvidia-modeset.ko -exec $objtool --hacks=jump_label --module --link {} \;
              '';
          });
        };
      });
    });
  });
}
