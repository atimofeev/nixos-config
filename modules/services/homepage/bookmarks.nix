{ lib, config, ... }:
{
  # NOTE: icons: https://gethomepage.dev/configs/services/#icons

  services.homepage-dashboard.bookmarks = [

    {
      work-main = [
        {
          jira-dashboard = [
            {
              abbr = "JI";
              href = "{{HOMEPAGE_VAR_JIRA_DASHBOARD_URL}}";
              icon = "jira.png";
            }
          ];
        }
        {
          jira-backlog = [
            {
              abbr = "JI";
              href = "{{HOMEPAGE_VAR_JIRA_BACKLOG_URL}}";
              icon = "jira.png";
            }
          ];
        }
        {
          confluence = [
            {
              abbr = "CF";
              href = "{{HOMEPAGE_VAR_CONFLUENCE_URL}}";
              icon = "si-confluence-#146CE7";
            }
          ];
        }
        {
          gitlab = [
            {
              abbr = "GL";
              href = "{{HOMEPAGE_VAR_GITLAB_URL}}";
              icon = "gitlab.png";
            }
          ];
        }
        {
          awx = [
            {
              abbr = "AW";
              href = "{{HOMEPAGE_VAR_AWX_URL}}";
              icon = "si-ansible-#BF2626";
            }
          ];
        }
        {
          vault = [
            {
              abbr = "VL";
              href = "{{HOMEPAGE_VAR_VAULT_URL}}";
              icon = "vault.svg";
            }
          ];
        }
        {
          portainer = [
            {
              abbr = "PT";
              href = "{{HOMEPAGE_VAR_PORTAINER_URL}}";
              icon = "portainer.svg";
            }
          ];
        }
      ];
    }

    {
      work-cloud = [
        {
          cloudflare = [
            {
              abbr = "CF";
              href = "{{HOMEPAGE_VAR_CLOUDFLARE_URL}}";
              icon = "cloudflare.svg";
            }
          ];
        }
        {
          aws_home = [
            {
              abbr = "AW";
              href = "{{HOMEPAGE_VAR_AWS_HOME_URL}}";
              icon = "si-amazonwebservices-#FF9900";
            }
          ];
        }
        {
          aws_login_main = [
            {
              abbr = "AW";
              href = "{{HOMEPAGE_VAR_AWS_LOGIN_MAIN_URL}}";
              icon = "si-amazonwebservices-#FF9900";
            }
          ];
        }
        {
          aws_login_gambite = [
            {
              abbr = "AW";
              href = "{{HOMEPAGE_VAR_AWS_LOGIN_GAMBITE_URL}}";
              icon = "si-amazonwebservices-#FF9900";
            }
          ];
        }
        {
          aws_login_k8s = [
            {
              abbr = "AW";
              href = "{{HOMEPAGE_VAR_AWS_LOGIN_K8S_URL}}";
              icon = "si-amazonwebservices-#FF9900";
            }
          ];
        }
        {
          nextcloud = [
            {
              abbr = "NC";
              href = "{{HOMEPAGE_VAR_NEXTCLOUD_URL}}";
              icon = "nextcloud.svg";
            }
          ];
        }
        {
          hetzner-cloud = [
            {
              abbr = "HZ";
              href = "{{HOMEPAGE_VAR_HETZNER_CLOUD_URL}}";
              icon = "hetzner.svg";
            }
          ];
        }
        {
          hetzner-robot = [
            {
              abbr = "HZ";
              href = "{{HOMEPAGE_VAR_HETZNER_ROBOT_URL}}";
              icon = "hetzner.svg";
            }
          ];
        }
      ];
    }

    {
      work-pve = [
        {
          prod-ah = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_PROD_AH_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
        {
          beta-ah = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_BETA_AH_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
        {
          prod-htz = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_PROD_HTZ_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
        {
          beta-htz = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_BETA_HTZ_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
        {
          beta-htz-fsn = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_BETA_HTZ_FSN_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
        {
          dyn-htz-fsn = [
            {
              abbr = "PM";
              href = "{{HOMEPAGE_VAR_PVE_DYN_HTZ_FSN_URL}}";
              icon = "proxmox.svg";
            }
          ];
        }
      ];
    }

    {
      work-monitor = [
        {
          prometheus = [
            {
              abbr = "PT";
              href = "{{HOMEPAGE_VAR_PROMETHEUS_URL}}";
              icon = "prometheus.svg";
            }
          ];
        }
        {
          alertmanager = [
            {
              abbr = "AM";
              href = "{{HOMEPAGE_VAR_ALERTMANAGER_URL}}";
              icon = "alertmanager.svg";
            }
          ];
        }
        {
          grafana = [
            {
              abbr = "GF";
              href = "{{HOMEPAGE_VAR_GRAFANA_URL}}";
              icon = "grafana.svg";
            }
          ];
        }
        {
          kibana = [
            {
              abbr = "KB";
              href = "{{HOMEPAGE_VAR_KIBANA_URL}}";
              icon = "kibana.svg";
            }
          ];
        }
      ];
    }

    {
      personal = [
        (lib.mkIf config.services.syncthing.enable {
          syncthing = [
            {
              abbr = "ST";
              href = "http://${toString config.services.syncthing.guiAddress}/";
              icon = "syncthing.svg";
            }
          ];
        })
        (lib.mkIf config.services.stirling-pdf.enable {
          stirling-pdf = [
            {
              abbr = "SP";
              href = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}/";
              icon = "sh-stirling-pdf";
            }
          ];
        })
        (lib.mkIf (config.virtualisation.oci-containers.containers ? convertx) {
          convertx = [
            {
              abbr = "CX";
              href = "http://127.0.0.1:3000";
              icon = "sh-convertx";
            }
          ];
        })
        (lib.mkIf (config.virtualisation.oci-containers.containers ? pihole) {
          pihole = [
            {
              abbr = "PH";
              href = "http://127.0.0.1:80";
              icon = "pi-hole.svg";
            }
          ];
        })
        {
          github = [
            {
              abbr = "GH";
              href = "https://github.com/atimofeev";
              icon = "si-github-#FFFFFF";
            }
          ];
        }
        {
          translate = [
            {
              abbr = "GT";
              href = "https://translate.google.com/";
              icon = "google-translate.svg";
            }
          ];
        }
        {
          youtube = [
            {
              abbr = "YT";
              href = "https://youtube.com/";
              icon = "youtube.svg";
            }
          ];
        }
        {
          mynixos = [
            {
              abbr = "MN";
              href = "https://mynixos.com/";
              icon = "si-nixos-#5277C3";
            }
          ];
        }
      ];
    }

    {
      ai = [
        (lib.mkIf config.services.open-webui.enable {
          open-webui = [
            {
              abbr = "WU";
              href = "http://127.0.0.1:${toString config.services.open-webui.port}";
              icon = "sh-open-webui";
            }
          ];
        })
        {
          chatgpt = [
            {
              abbr = "CG";
              href = "https://chat.openai.com/";
              icon = "chatgpt.svg";
            }
          ];
        }
        {
          claude = [
            {
              abbr = "CL";
              href = "https://claude.ai/new";
              icon = "si-anthropic-#191919";
            }
          ];
        }
        {
          deepseek = [
            {
              abbr = "DS";
              href = "https://chat.deepseek.com/";
            }
          ];
        }
        {
          gemini = [
            {
              abbr = "GM";
              href = "https://gemini.google.com/app";
              icon = "google-gemini";
            }
          ];
        }
      ];
    }
    {
      utils = [
        {
          oryx = [
            {
              abbr = "OX";
              href = "https://configure.zsa.io/voyager/layouts/VRLP7/latest/0";
              icon = "sh-goatcounter";
            }
          ];
        }
        {
          diffchecker = [
            {
              abbr = "DC";
              href = "https://diffchecker.com/text-compare/";
              icon = "mdi-vector-difference-#41EDB3";
            }
          ];
        }
        {
          draw-io = [
            {
              abbr = "DR";
              href = "https://app.diagrams.net/";
              icon = "diagrams-net.svg";
            }
          ];
        }
      ];
    }

  ];
}
