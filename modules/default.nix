{

  imports = [

    ./hardware/asus-backlight-fix.nix
    ./hardware/asus-fn-lock-fix.nix
    ./hardware/asus-linux.nix
    ./hardware/bluetooth.nix
    ./hardware/logitech.nix
    ./hardware/motiff-ii-fix.nix
    ./hardware/nvidia.nix
    ./hardware/power.nix
    ./hardware/razer.nix
    ./hardware/sound.nix
    ./hardware/ssd.nix
    ./hardware/zsa.nix

    # TODO: separate hard-coded modules from optional ones
    ./system/automount.nix
    ./system/boot.nix
    ./system/catppuccin.nix
    ./system/fonts.nix
    ./system/home-manager.nix
    ./system/lanzaboote.nix
    ./system/locale.nix
    ./system/logind.nix
    ./system/network.nix
    ./system/nix.nix
    ./system/secrets.nix
    ./system/sops.nix
    ./system/sudo.nix
    ./system/user.nix

    ./apps/chromium.nix
    ./apps/games.nix
    ./apps/gui.nix
    ./apps/terminal.nix

    ./services/auto-cpufreq.nix
    ./services/convertx.nix
    ./services/docker.nix
    ./services/homepage
    ./services/kanata.nix
    ./services/logrotate-nvim.nix
    ./services/ollama.nix
    ./services/pihole.nix
    ./services/power-profiles-daemon.nix
    ./services/printing.nix
    ./services/stirling-pdf.nix
    ./services/sunshine.nix
    ./services/thermald.nix
    ./services/tlp.nix
    ./services/yubikey.nix

    ./work/ansible.nix
    ./work/cato.nix
    ./work/falcon.nix
    ./work/jira-cli.nix
    ./work/kube-tools.nix
    ./work/misc-tools.nix
    ./work/opentofu.nix
    ./work/openvpn.nix
    ./work/wpa2-enterprise-fix.nix

  ];

}
