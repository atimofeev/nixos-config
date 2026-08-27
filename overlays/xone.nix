# Experimental xone patches: dlundqvist/xone PR #193 (cold boot fixes,
# head c74f9794a502e93f5fd4b51004ce47c2b0af698c) and PR #216 (resume radio
# recalibration, commit 94ccf2d4ef1a67bf751d6c8fbd98a948b659dcca). Both are
# open/unmerged; PR #193 reverts merged work (usb_reset_device removal), so
# treat as regression risk. Apply in order #193 then #216 against v0.5.8.

_final: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (
    _kfinal: kprev: {
      xone = kprev.xone.overrideAttrs (oldAttrs: {
        __intentionallyOverridingVersion = true;
        patches = (oldAttrs.patches or [ ]) ++ [
          ./patches/xone-p193-cold-boot-fixes.patch
          ./patches/xone-p216-resume-radio-recalibration.patch
        ];
        version = "${oldAttrs.version}-p193-p216";
      });
    }
  );
}
