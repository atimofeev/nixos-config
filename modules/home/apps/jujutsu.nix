{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.jujutsu;
in
{

  options.custom-hm.applications.jujutsu = {
    enable = lib.mkEnableOption "jujutsu bundle";
    package = lib.mkPackageOption pkgs "jujutsu" { };
  };

  config = lib.mkIf cfg.enable {

    custom-hm.user.shellAliases = {
      jb = "jj bookmark list";
      jc = "jj commit";
      jd = "jj diff";
      je = "jj edit";
      jf = "jj git fetch";
      ji = "jj git init";
      jl = "jj log";
      jn = "jj new";
      jp = "jj git push";
      js = "jj status";
      jsq = "jj squash";
      jsp = "jj split";
    };

    programs = {

      jujutsu = {
        enable = true;
        inherit (cfg) package;
        settings = {
          aliases = {
            b = [ "bookmark" ];
            ci = [ "commit" ];
            d = [ "diff" ];
            f = [
              "git"
              "fetch"
            ];
            l = [ "log" ];
            n = [ "new" ];
            p = [
              "git"
              "push"
            ];
            s = [ "status" ];
          };

          diff = {
            color-words.context = 3;
            git.context = 3;
          };

          git = {
            colocate = true;
          };

          remotes = {
            origin = {
              auto-track-created-bookmarks = "*";
            };
          };

          ui = {
            color = "auto";
            conflict-marker-style = "git";
            diff-formatter = ":git";
            editor = config.custom-hm.user.editor;
            graph.style = "curved";
            pager = [
              "sh"
              "-c"
              "${lib.getExe pkgs.diff-so-fancy} | ${lib.getExe pkgs.less} -RFX"
            ];
          };

          user = {
            email = "39891735+atimofeev@users.noreply.github.com";
            name = "Artem Timofeev";
          };
        };
      };

    };

  };

}
