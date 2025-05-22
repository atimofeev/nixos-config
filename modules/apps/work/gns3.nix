{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    gns3-gui
    libvirt
  ];
  # FIX: https://github.com/NixOS/nixpkgs/pull/303442
  services.gns3-server = {
    enable = true;
    ubridge.enable = true;
    dynamips.enable = true;
    vpcs.enable = true;
  };
  services.gns3-server.settings = {
    Server.ubridge_path = pkgs.lib.mkForce "/run/wrappers/bin/ubridge";
  };
  users.groups.gns3 = { };
  users.users.gns3 = {
    group = "gns3";
    isSystemUser = true;
  };
  systemd.services.gns3-server.serviceConfig = {
    User = "gns3";
    DynamicUser = pkgs.lib.mkForce false;
    NoNewPrivileges = pkgs.lib.mkForce false;
    RestrictSUIDSGID = pkgs.lib.mkForce false;
    PrivateUsers = pkgs.lib.mkForce false;
    DeviceAllow = [
      "/dev/net/tun rw"
      "/dev/net/tap rw"
    ] ++ pkgs.lib.optionals config.virtualisation.libvirtd.enable [ "/dev/kvm" ];
  };

  # virtualisation.vmware.host.enable = true;
  # # NOTE: fix vmware-workstation download URLs
  # nixpkgs.overlays = [
  #   (self: super: {
  #     vmware-workstation = super.vmware-workstation.overrideAttrs
  #       (vself: vsuper:
  #         let
  #           urlBase =
  #             "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${vself.version}/${vself.build}/linux/";
  #           file =
  #             "VMware-Workstation-${vself.version}-${vself.build}.x86_64.bundle";
  #         in {
  #           src = "${
  #               self.fetchzip {
  #                 url = urlBase + "core/${file}.tar";
  #                 hash = "sha256-nYkqZ7w3AYdw2YvQNATIYeJpqUwmkLE6jzyQlhGKyEs=";
  #                 stripRoot = false;
  #               }
  #             }/${file}";
  #           unpackPhase = let
  #             vmware-unpack-env = self.buildFHSEnv {
  #               name = "vmware-unpack-env";
  #               targetPkgs = pkgs: [ self.zlib ];
  #             };
  #             vmware-tools = let
  #               version = "12.3.5";
  #               build = "22544099";
  #               file = system:
  #                 "vmware-tools-${system}-${version}-${build}.x86_64.component";
  #               hashes = {
  #                 linux = "sha256-VHFc2g9Bpz7RaJDTB+MXZ2VKe6YfcM1Y2qcqL75mOgw=";
  #                 linuxPreGlibc25 =
  #                   "sha256-ubxS82tyY/biGSBPvPFsggKLYRXUMVJU9dqNfILa7OY=";
  #                 netware =
  #                   "sha256-Fs+R4RTgbV+SlFuz7DO/NXdqfMMXf05eSmIfD8AWjvI=";
  #                 solaris =
  #                   "sha256-HajtvDG/iPUmi7clO2wkSQRMWsOI/rLFHVDlw/vL4wI=";
  #                 winPre2k =
  #                   "sha256-lX4uvJRFSUIzm6cxCCuZwrsgPuRE2Wr1+GYFY0Qk8Tw=";
  #                 winPreVista =
  #                   "sha256-xA3UvxIS7u435T0LsyMTCHFUZL9dkTXuekXexOWkXRc=";
  #                 windows =
  #                   "sha256-/UrzEQTBhmuQODnNoNPQD4pI4MNCxordb/FxVPS3A9o=";
  #               };
  #               srcs = map (system:
  #                 "${
  #                   self.fetchzip {
  #                     url = urlBase + "packages/${file system}.tar";
  #                     hash = hashes.${system};
  #                     stripRoot = false;
  #                   }
  #                 }/${file system}") (builtins.attrNames hashes);
  #             in lib.concatMapStringsSep " " (src: "--install-component ${src}")
  #             srcs;
  #           in ''
  #             ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${vself.src} ${vmware-tools} --extract unpacked"
  #           '';
  #         });
  #   })
  # ];
}
