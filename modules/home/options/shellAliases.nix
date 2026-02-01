{ config, lib, ... }:
let
  cfg = config.custom-hm.user.shellAliases;
in
{

  options.custom-hm.user = {

    shellAliases = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
    };

  };

  config = {
    programs = {
      bash = lib.mkIf config.programs.bash.enable { shellAliases = cfg; };
      fish = lib.mkIf config.programs.fish.enable { shellAliases = cfg; };
      zsh = lib.mkIf config.programs.zsh.enable { shellAliases = cfg; };

      nushell = lib.mkIf config.programs.nushell.enable {
        shellAliases = lib.attrsets.removeAttrs cfg [
          "shell"
          "du"
          "mkdir"
        ];
      };
    };
  };

}
