{

  imports = [

    ./hardware/bluetooth.nix
    ./hardware/intel-kaby-lake.nix
    ./hardware/logitech.nix
    ./hardware/nvidia.nix
    ./hardware/power.nix
    ./hardware/razer.nix
    ./hardware/sound.nix
    ./hardware/ssd.nix
    ./hardware/zsa.nix

    # TODO: separate hard-coded modules from optional ones
    ./system/automount.nix
    ./system/boot.nix
    ./system/fonts.nix
    ./system/home-manager.nix
    ./system/locale.nix
    ./system/logind.nix
    ./system/network.nix
    ./system/nix.nix
    ./system/sops.nix
    ./system/sudo.nix
    ./system/user.nix

    # TODO: optionalize
    ./apps/chromium.nix
    ./apps/games.nix
    ./apps/gui.nix
    ./apps/terminal.nix

    ./services/homepage
    ./services/auto-cpufreq.nix
    ./services/convertx.nix
    ./services/docker.nix
    ./services/kanata.nix
    ./services/logrotate-nvim.nix
    ./services/nbfc.nix # FIX: broken
    ./services/ollama.nix
    ./services/pihole.nix
    ./services/stirling-pdf.nix
    ./services/syncthing.nix
    ./services/thermald.nix
    ./services/tlp.nix
    # ./services/xremap.nix # FIX: broken
    ./services/yubikey.nix

    ./work/ansible.nix
    ./work/cato.nix
    ./work/falcon.nix
    ./work/kube-tools.nix
    ./work/misc-tools.nix
    ./work/opentofu.nix
    ./work/openvpn.nix
    ./work/wpa2-enterprise-fix.nix

  ];

}
