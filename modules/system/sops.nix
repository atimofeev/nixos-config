{ inputs, pkgs, vars, ... }: {

  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = [ pkgs.sops ];

  sops = {
    age.sshKeyPaths = [ "/home/${vars.username}/.ssh/id_ed25519" ];
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # HACK: too lazy to implement proper home-manager integration into sops
    secrets = {
      # ../../home/terminal/apps/spotify-player.nix
      "personal/spotify-client-id".owner = vars.username;
      # ../desktop/hyprland/config/apps/hyprpanel.nix
      "personal/weather-api.json".owner = vars.username;
    };
  };

}
