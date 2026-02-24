{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.git;
in
{

  options.custom-hm.applications.git = {
    enable = lib.mkEnableOption "git bundle";
    package = lib.mkPackageOption pkgs "git" { };
  };

  config = lib.mkIf cfg.enable {

    custom-hm.user.shellAliases = {
      gs = "git status --short";
      gd = "git diff";
      ga = "git add";
      gap = "git add --patch";
      gc = "git commit";
      gp = "git push";
      gP = "git pull";
      gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
      gb = "git branch";
      gi = "git init";
      gcl = "git clone";
    };

    programs = {

      diff-so-fancy = {
        enable = true;
        enableGitIntegration = true;
        settings = {
          markEmptyLines = false;
        };
      };

      git = {
        enable = true;
        inherit (cfg) package;
        settings = {
          user = {
            name = "Artem Timofeev";
            email = "39891735+atimofeev@users.noreply.github.com";
          };
        };
        ignores = [
          "*.swp"
          ".null-ls_*"
          ".terraform*"
          "terraform.tfstate*"
        ];
        includes = [
          {
            path = "~/repos/betby/.gitconfig";
            condition = "gitdir:~/repos/betby/";
          }
        ];
        settings = {
          # commit.gpgSign = true;
          # user.signingkey = "123456";
          advice = {
            addEmptyPathspec = false;
            pushNonFastForward = false;
            statusHints = false;
          };
          branch = {
            sort = "-committerdate";
          };
          color = {
            decorate = {
              HEAD = "red";
              branch = "blue";
              remoteBranch = "magenta";
              tag = "yellow";
            };
            branch = {
              current = "magenta";
              local = "default";
              plain = "blue";
              remote = "yellow";
              upstream = "green";
            };
          };
          core = {
            compression = 9;
            preloadindex = true;
            whitespace = "error";
          };
          diff = {
            context = 3;
            interHunkContext = 10;
            renames = "copies";
          };
          init.defaultBranch = "main";
          interactive = {
            singlekey = true;
          };
          log = {
            abbrevCommit = true;
            graphColors = "blue,yellow,cyan,magenta,green,red";
          };
          pager = {
            branch = false;
            tag = false;
          };
          pull = {
            default = "current";
            rebase = true;
          };
          push = {
            autoSetupRemote = true;
            default = "current";
            followTags = true;
          };
          status = {
            branch = true;
            showStash = true;
            showUntackedFiles = "all";
          };
          tag = {
            sort = "-taggerdate";
          };
          url = {
            "git@github.com:".insteadOf = "gh:";
          };
        };
      };

    };

  };

}
