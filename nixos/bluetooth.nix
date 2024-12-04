{ pkgs, ... }: {

  # Fix 'headset' output (only 'handsfree' working)
  nixpkgs.overlays = [
    (final: _prev: {
      bluez566 = import (builtins.fetchTarball {
        url =
          # 5.66
          "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
        sha256 = "sha256:17v6wigks04x1d63a2wcd7cc4z9ca6qr0f4xvw1pdw83f8a3c0nj";
        # 5.71
        #   "https://github.com/NixOS/nixpkgs/archive/442d407992384ed9c0e6d352de75b69079904e4e.tar.gz";
        # sha256 = "sha256:0rbaxymznpr2gfl5a9jyii5nlpjc9k2lrwlw2h5ccinds58c202k";
      }) { inherit (final) system; };
    })
  ];

  hardware.bluetooth = {
    enable = true;
    # package = pkgs.bluez566.bluez;
    settings = {

      Policy.AutoEnable = true;

      General = {
        ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = true;
      };

    };
  };

}
