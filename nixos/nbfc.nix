{ pkgs, vars, ... }:
# NOTE: https://github.com/nbfc-linux/nbfc-linux/blob/main/nixos-installation-new.md
let

  configName = "Xiaomi Mi Book (TM1613, TM1703)";

  command =
    "bin/nbfc_service --config-file '/home/${vars.username}/.config/nbfc.json'";

in {

  home-manager.users.${vars.username} = {
    xdg.configFile = {
      "nbfc.json" = {
        text = # json
          ''
            {"SelectedConfigId": "${configName}"}
          '';

      };
    };
  };

  environment.systemPackages = with pkgs; [ unstable.nbfc-linux ];
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type = "simple";
    path = [ pkgs.kmod ];
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.unstable.nbfc-linux}/${command}";
  };

}
