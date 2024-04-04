{ nixpkgs-unstable, pkgs-unstable, vars, ... }: {
  # NOTE: override service channel to unstable
  imports = [
    (nixpkgs-unstable + "/nixos/modules/services/misc/homepage-dashboard.nix")
  ];

  disabledModules = [ "services/misc/homepage-dashboard.nix" ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      homepage-dashboard = pkgs-unstable.homepage-dashboard;
    };
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8888;

    settings = {
      title = "${vars.username} dashboard";
      background = {
        # image = "../assets/wallpaper.jpg";
        # blur = "sm";
        saturate = 50;
        brightness = 50;
        opacity = 50;
      };
      cardBlur = "sm";
      theme = "dark";
      # color = "zinc";
      # iconStyle = "theme";
      # statusStyle = "dot";

      target = "_blank"; # open links in new tabs

      hideVersion = true;
      # disableCollapse = true;
    };
    bookmarks = [
      {
        work = [
          {
            gitlab = [{
              abbr = "GL";
              href = "https://git.devspt.com/";
              icon = "gitlab.png";
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
            prom-ams1 = [{
              abbr = "PT";
              href = "http://prom1-ams1.devspt.com:9090/";
              icon = "prometheus.svg";
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
            portainer = [{
              abbr = "PT";
              href = "https://portainer1-ams1.devspt.com/";
              icon = "portainer.svg";
            }];
          }
          {
            cloudflare = [{
              abbr = "CF";
              href = "https://dash.cloudflare.com/";
              icon = "cloudflare.svg";
            }];
          }
          {
            aws_main = [{
              abbr = "AW";
              href = "https://370297574318.signin.aws.amazon.com/console";
              icon = "aws.svg";
            }];
          }
          {
            aws_gambite = [{
              abbr = "AW";
              href = "https://450341735216.signin.aws.amazon.com/console";
              icon = "aws.svg";
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
              icon = "github.svg";
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
              icon = "nix.svg";
            }];
          }
        ];
      }
    ];
    # services = "";
    widgets = [
      {
        search = {
          provider = "google";
          target = "_blank";
        };
      }
      {
        resources = {
          label = "system";
          cpu = true;
          memory = true;
        };
      }
      {
        resources = {
          label = "storage";
          disk = [ "/" ];
        };
      }
      {
        openmeteo = {
          label = "Tbilisi";
          timezone = "Asia/Tbilisi";
          latitude = "41.70696381385158";
          longitude = "44.883735610511145";
          units = "metric";
        };
      }
    ];

  };
}
