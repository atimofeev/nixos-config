{ vars, ... }: {
  # NOTE: icons: https://gethomepage.dev/main/configs/services/#icons
  # https://github.com/walkxcode/dashboard-icons

  # TODO: configure
  # https://github.com/jnsgruk/nixos-config/blob/2869fc81225903238fecb34b82ebe11699d98fa4/host/common/services/homepage/thor.nix#L13
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8888;

    settings = {
      title = "${vars.username} dashboard";
      background = {
        image =
          "https://raw.githubusercontent.com/atimofeev/nixos-config/main/assets/dark-shore.png";
        # blur = "sm";
        saturate = 50;
        brightness = 85;
        opacity = 50;
      };
      cardBlur = "sm";
      theme = "dark";
      color = "slate";

      target = "_blank"; # open links in new tabs

      hideVersion = true;
    };

    bookmarks = [
      {
        work-main = [
          {
            jira = [{
              abbr = "JI";
              href = "https://betby.atlassian.net/jira/dashboards/10024";
              icon = "jira.png";
            }];
          }
          {
            confluence = [{
              abbr = "CF";
              href = "https://betby.atlassian.net/wiki/home";
              icon = "si-confluence-#146CE7";
            }];
          }
          {
            gitlab = [{
              abbr = "GL";
              href = "https://git.devspt.com/";
              icon = "gitlab.png";
            }];
          }
          {
            awx = [{
              abbr = "AW";
              href = "https://awx.devspt.com/ui_next";
              icon = "si-ansible-#BF2626";
            }];
          }
          {
            vault = [{
              abbr = "VL";
              href = "https://vault.devspt.com/";
              icon = "vault.svg";
            }];
          }
          {
            portainer = [{
              abbr = "PT";
              href = "https://portainer1-ams1.devspt.com/";
              icon = "portainer.svg";
            }];
          }
        ];
      }
      {
        work-cloud = [
          {
            cloudflare = [{
              abbr = "CF";
              href = "https://dash.cloudflare.com/";
              icon = "cloudflare.svg";
            }];
          }
          {
            aws_home = [{
              abbr = "AW";
              href = "https://eu-central-1.console.aws.amazon.com/console/home";
              icon = "aws.svg";
            }];
          }
          {
            aws_login_main = [{
              abbr = "AW";
              href = "https://370297574318.signin.aws.amazon.com/console";
              icon = "aws.svg";
            }];
          }
          {
            aws_login_gambite = [{
              abbr = "AW";
              href = "https://450341735216.signin.aws.amazon.com/console";
              icon = "aws.svg";
            }];
          }
          {
            nextcloud = [{
              abbr = "NC";
              href = "https://c.devspt.com/";
              icon = "nextcloud.svg";
            }];
          }
        ];
      }
      {
        work-monitor = [
          {
            prom-ams1 = [{
              abbr = "PT";
              href = "http://prom1-ams1.devspt.com:9090/";
              icon = "prometheus.svg";
            }];
          }
          {
            alertmgr-ams1 = [{
              abbr = "AM";
              href = "http://alertmgr1-ams1.devspt.com:9093";
              icon = "alertmanager.svg";
            }];
          }
          {
            grafana = [{
              abbr = "GF";
              href = "https://grafana.devspt.com/";
              icon = "grafana.svg";
            }];
          }
          {
            kibana = [{
              abbr = "KB";
              href = "https://kibana.devspt.com/";
              icon = "kibana.svg";
            }];
          }
        ];
      }
      {
        personal = [
          {
            github = [{
              abbr = "GH";
              href = "https://github.com/atimofeev";
              icon = "si-github-#FFFFFF";
            }];
          }
          {
            chatgpt = [{
              abbr = "CG";
              href = "https://chat.openai.com/";
              icon = "chatgpt.svg";
            }];
          }
          {
            translate = [{
              abbr = "GT";
              href = "https://translate.google.com/";
              icon = "google-translate.svg";
            }];
          }
          {
            youtube = [{
              abbr = "YT";
              href = "https://youtube.com/";
              icon = "youtube.svg";
            }];
          }
          {
            mynixos = [{
              abbr = "MN";
              href = "https://mynixos.com/";
              icon = "si-nixos-#5277C3";
            }];
          }
        ];
      }

      {
        utils = [
          {
            diffchecker = [{
              abbr = "DC";
              href = "https://diffchecker.com/text-compare/";
            }];
          }
          {
            draw-io = [{
              abbr = "DR";
              href = "https://app.diagrams.net/";
              icon = "diagrams-net.svg";
            }];
          }
        ];
      }
    ];

    widgets = [
      {
        search = {
          provider = "google";
          target = "_blank";
        };
      }
      {
        resources = {
          cpu = true;
          memory = true;
          disk = [ "/" ];
        };
      }
      {
        openmeteo = {
          label = "Tbilisi";
          timezone = "Asia/Tbilisi";
          latitude = "41.697006";
          longitude = "44.798851";
          units = "metric";
        };
      }
    ];

  };
}
