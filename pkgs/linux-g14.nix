{ pkgs, lib, ... }:

let
  g14 = pkgs.fetchFromGitLab {
    owner = "asus-linux";
    repo = "linux-g14";
    rev = "6d082ec0868f945c5fa49cec2eab38d64d0c6b2e";
    hash = "sha256-HAvENk6Urga0TnvvJJhFIBlTu3w+8ICWkxt844kpM1U=";
  };
  patches = [
    "sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.15.patch"
    "0001-platform-x86-asus-wmi-export-symbols-used-for-read-w.patch"
    "0002-platform-x86-asus-armoury-move-existing-tunings-to-a.patch"
    "0003-platform-x86-asus-armoury-add-panel_hd_mode-attribut.patch"
    "0004-platform-x86-asus-armoury-add-apu-mem-control-suppor.patch"
    "0005-platform-x86-asus-armoury-add-screen-auto-brightness.patch"
    "0006-platform-x86-asus-wmi-deprecate-bios-features.patch"
    "0007-platform-x86-asus-wmi-rename-ASUS_WMI_DEVID_PPT_FPPT.patch"
    "0008-platform-x86-asus-armoury-add-ppt_-and-nv_-tuning-kn.patch"
    "0001-platform-x86-asus-armoury-Fix-error-code-in-mini_led.patch"
    "0002-platform-x86-asus-armoury-fix-mini-led-mode-show.patch"
    "0003-platform-x86-asus-armoury-add-support-for-FA507UV.patch"
    "0001-platform-x86-asus-armoury-fix-only-DC-tunables-being.patch"
    "PATCH-v10-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling.patch"
    "PATCH-v10-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling-id1-id2-pr_err.patch"
    "0001-platform-x86-asus-wmi-fix-initializing-TUFs-keyboard.patch"
    "0002-platform-x86-asus-armoury-add-keyboard-control-firmw.patch"
    "0001-acpi-proc-idle-skip-dummy-wait.patch"
    "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
    "PATCH-asus-wmi-fixup-screenpad-brightness.patch"
    "asus-patch-series.patch"
    "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
    "0040-workaround_hardware_decoding_amdgpu.patch"
    "0081-amdgpu-adjust_plane_init_off_by_one.patch"
    "0084-enable-steam-deck-hdr.patch"
    "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
    "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
  ];
in
pkgs.linuxPackagesFor (
  pkgs.linux_6_18.override {
    argsOverride = rec {
      src = pkgs.stdenv.mkDerivation {
        name = "linux-g14";
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          hash = "sha256-0KeL8/DRKqoQrzta3K7VvHZ7W3hwXl74hdXpMLcuJdU=";
        };
        buildPhase = ''
          cp $src -r .
          for patch in ${lib.concatMapStringsSep " " (file: "\"${file}\"") patches}; do
            patch -Np1 -F150 < ${g14}/$patch
          done
        '';
        installPhase = ''
          cp -r . $out
        '';
      };
      version = "6.18.1";
      modDirVersion = "6.18.1";

      # Config from the g14 kernel
      # Note: the order matters, unlike in the linux-g14 repo
      # See https://github.com/NixOS/nixpkgs/issues/82951#issuecomment-602031597
      extraConfig = ''
        ASUS_WMI_BIOS y
        CONFIG_HID_ASUS_ALLY m
        ASUS_ARMOURY m
        CONFIG_ASUS_WMI_DEPRECATED_ATTRS y
        CONFIG_DRM_AMD_COLOR_STEAMDECK y
      '';
      ignoreConfigErrors = true;
    };
  }
)
