{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.atuin;
in
{
  options.custom-hm.applications.atuin = {
    enable = lib.mkEnableOption "atuin bundle";
    package = lib.mkPackageOption pkgs "atuin" { };
    sync = {
      enable = lib.mkEnableOption "Enable sync";
      address = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.atuin = {
          enable = true;
          inherit (cfg) package;

          enableBashIntegration = config.programs.bash.enable;
          enableFishIntegration = config.programs.fish.enable;
          enableNushellIntegration = config.programs.nushell.enable;
          enableZshIntegration = config.programs.zsh.enable;

          flags = [ "--disable-up-arrow" ];
          forceOverwriteSettings = true;

          settings = {
            dialect = "uk";
            enter_accept = true;
            search_mode = "fuzzy";
            style = "compact";
            update_check = false;
            workspaces = true;
          };
        };
      }

      (lib.mkIf cfg.sync.enable {
        programs.atuin = {
          daemon.enable = true;
          settings = {
            auto_sync = true;
            sync_address = cfg.sync.address;
          };
        };
      })
    ]
  );
}
