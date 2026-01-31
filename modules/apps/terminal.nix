{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.applications.common-terminal;
in
{

  options.custom.applications.common-terminal = {
    enable = lib.mkEnableOption "common-terminal bundle";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      # utils
      bc
      coreutils
      curl-ws
      file
      jq
      nmap
      unzip
      usbutils
      util-linux
      wget
      wl-clipboard
      yq-go

      # improved utils
      duf # df
      dust # du
      eza # ls
      fd # find
      gping
      ripgrep # grep
      unstable.snitch # ss
      xh # curl

      # misc
      ani-cli
      fzf
      gemini-cli
      nvidia-hide
      tldr

      # fun
      cbonsai
      cmatrix
      lavat
      lolcat
      neo
      pipes

    ];

  };

}
