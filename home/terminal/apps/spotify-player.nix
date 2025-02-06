{ osConfig, vars, ... }: {

  programs.spotify-player = {
    enable = true;
    settings = {
      # NOTE: not working
      client_id_command =
        "cat ${osConfig.sops.secrets."personal/spotify-client-id".path}";
      liked_icon = "";
      device = {
        volume = 85;
        autoplay = true;
      };
    };
  };

  # NOTE: see ../../../modules/system/sops.nix
  # sops.secrets = { "personal/spotify-client-id".owner = vars.username; };

  # TODO: integrate credentials from sops
  # ~/.cache/spotify-player/credentials.json
  # https://github.com/71zenith/kiseki/blob/2b85b44338b369a4d22baae2e684fa783e64afc2/home/spotify-player.nix#L47

}
