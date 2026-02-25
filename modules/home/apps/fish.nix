{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.fish;
in
{

  options.custom-hm.applications.fish = {
    enable = lib.mkEnableOption "fish bundle";
    package = lib.mkPackageOption pkgs "fish" { };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.fish_greeting = "";

      packages = with pkgs.fishPlugins; [
        autopair
        bang-bang
        puffer
      ];
    };

    programs.fish = {
      enable = true;
      inherit (cfg) package;

      functions = {

        fish_user_key_bindings = # fish
          ''
            bind \cf fg # Ctrl-f - `fg`
          '';

        # touchx = # fish
        #   ''
        #     for file in $argv
        #         touch $file
        #         chmod +x $file
        #     end
        #   '';

        # dn = "$argv 2>/dev/null";

        # ex = # fish
        #   ''
        #     if not test -f "$argv[1]"
        #         echo "'$argv[1]' is not a valid file"
        #         return
        #     end
        #
        #     switch "$argv[1]"
        #         case '*.tar.bz2' '*.tbz2'
        #             tar xjf $argv[1]
        #         case '*.tar.gz' '*.tgz'
        #             tar xzf $argv[1]
        #         case '*.bz2'
        #             bunzip2 $argv[1]
        #         case '*.rar'
        #             unrar x $argv[1]
        #         case '*.gz'
        #             gunzip $argv[1]
        #         case '*.tar'
        #             tar xf $argv[1]
        #         case '*.zip'
        #             unzip $argv[1]
        #         case '*.Z'
        #             uncompress $argv[1]
        #         case '*.7z'
        #             7z x $argv[1]
        #         case '*.tar.xz'
        #             tar -Jxf $argv[1]
        #         case '*.tar.zst'
        #             unzstd $argv[1]
        #         case '*'
        #             echo "'$argv[1]' cannot be extracted via ex()"
        #     end
        #   '';

      };

      # TODO: add custom fzf functions
    };

  };

}
