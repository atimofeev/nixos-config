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
      curl
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
      xh # curl
      dust # du
      eza # ls
      fd # find
      ripgrep # grep
      gping

      # misc
      fzf
      tldr
      ani-cli
      gemini-cli

      # fun
      lolcat
      pipes
      cmatrix
      neo
      cbonsai
      lavat

    ];

  };

}
