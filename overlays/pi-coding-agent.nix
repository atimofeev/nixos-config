{ config, pkgs, ... }:
_final: prev: {
  unstable = prev.unstable // {
    pi-coding-agent = prev.unstable.pi-coding-agent.overrideAttrs (old: {

      # Use interpolation inside the block to ensure proper line breaks!
      postFixup = ''
        ${old.postFixup or ""}

        wrapProgram "$out/bin/pi" \
          --set NPM_CONFIG_PREFIX "/home/${config.custom.hm-admin}/.pi/npm/" \
          --set AWS_PROFILE "ai" \
          --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.unstable.nodejs_latest ]}"
      '';

    });
  };
}
