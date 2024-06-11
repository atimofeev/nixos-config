{ pkgs, ... }: {
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # FIX: Mi Notebook: Fix +30db default gain on built-in mic
  # Replicate this: https://forum.endeavouros.com/t/microphone-gain-is-way-too-much-on-100/40575/4
  # or this: https://github.com/0x61nas/nixfiles/blob/3ca7daa5d07716a3aa4c5113af6a5ca5263a6089/modules/workarounds/pulseaudio-mic-boost.nix
  # or: https://github.com/ReedClanton/NixOS/blob/376707d93bb90954f9ad377b2b9a791e2e6de744/modules/nixos/sound/default.nix
  environment.etc."alsa-state.conf".source = ../assets/alsa-state.conf;
  environment.systemPackages = with pkgs; [ alsaUtils ];
  systemd.services.load-alsa-state = {
    after = [ "sound.target" "pulseaudio.service" "pipewire.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.alsaUtils}/bin/alsactl -f /etc/alsa-state.conf restore
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
