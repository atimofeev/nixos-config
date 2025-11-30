{ config, ... }:
{

  sops.secrets."work/gitlab-config" = {
    path = "${config.home.homeDirectory}/repos/betby/.gitconfig";
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

}
