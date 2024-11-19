{ pkgs, lib, vars, ... }:
# NOTE: Probably just need to thoroughly RTFM!
# https://wiki.archlinux.org/title/PipeWire
# https://wiki.archlinux.org/title/WirePlumber
# https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture

let
  # Patch out microphone boost. Done when boost defaults to on and breaks microphone.
  # See: https://community.frame.work/t/microphone-extremely-staticy/15533/12
  pipewire-no-mic-boost = let volumeLevel = 50;
  in pkgs.unstable.pipewire.overrideAttrs (og-pkg: {
    name = "${og-pkg.pname}-no-mic-boost";
    buildCommand = # bash
      ''
        set -euo pipefail

        # Copy original files, for each split-output (`out`, `dev` etc.).
        # TODO: Remove hard coded refrence to pipewire so this function will
        #   work with any package.
        ${lib.concatStringsSep "\n" (map (outputName: ''
          echo "Copying output ${outputName}"
          set -x
          cp -a ${pkgs.unstable.pipewire.${outputName}} ''$${outputName}
          set +x
        '') og-pkg.outputs)}

        set -x

        # Find mic device name in `pw-dump` output

        INFILE=$out/share/alsa-card-profile/mixer/paths/analog-input-internal-mic.conf

        cat $INFILE | \
          ${pkgs.python3}/bin/python -c \
            'import re,sys; print(re.sub("\[Element Capture\]\nswitch = mute\nvolume = merge", "[Element Capture]\nswitch = mute\nvolume = ${
              toString volumeLevel
            }", sys.stdin.read()))' | \
             ${pkgs.python3}/bin/python -c \
            'import re,sys; print(re.sub("\[Element Internal Mic Boost\]\nrequired-any = any\nswitch = select\nvolume = merge", "[Element Internal Mic Boost]\nrequired-any = any\nswitch = select\nvolume = 0", sys.stdin.read()))' | \
            ${pkgs.python3}/bin/python -c \
            'import re,sys; print(re.sub("\[Element Int Mic Boost\]\nrequired-any = any\nswitch = select\nvolume = merge", "[Element Int Mic Boost]\nrequired-any = any\nswitch = select\nvolume = 0", sys.stdin.read()))' > \
            tmp.conf

        # Ensure file changed (something was replaced)
        ! cmp tmp.conf $INFILE
        chmod +w $INFILE
        cp tmp.conf $INFILE

        set +x
      '';
  });
in {
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.${vars.username}.extraGroups = [ "audio" ];

  services.pipewire = {
    enable = true;
    package = pipewire-no-mic-boost;
    wireplumber.package =
      pkgs.wireplumber.override { pipewire = pipewire-no-mic-boost; };
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      # "10-logging" = { "context.properties"."log.level" = 3; };
    };
  };

  # FIX: Mi Notebook: Fix +30db default gain on built-in mic
  # Replicate this: https://forum.endeavouros.com/t/microphone-gain-is-way-too-much-on-100/40575/4
  # or this: https://github.com/0x61nas/nixfiles/blob/3ca7daa5d07716a3aa4c5113af6a5ca5263a6089/modules/workarounds/pulseaudio-mic-boost.nix
  # or: https://github.com/ReedClanton/NixOS/blob/376707d93bb90954f9ad377b2b9a791e2e6de744/modules/nixos/sound/default.nix
  # https://github.com/little-dude/home/blob/570c32312c93f2359e2b62e3fcea8432c1fec4ee/nix/os/renzo.nix#L107
  # https://github.com/kittywitch/arcnmx-home/blob/f40988631ca8473f5207bc966dae10ef015eb4e0/nodes/shanghai/audio.nix#L346
  # https://github.com/NixOS/nixpkgs/issues/24184
  # https://unix.stackexchange.com/questions/336790/how-to-prevent-white-noise-in-headphones-on-dell-xps-13-9350-9360/581386#581386

}
