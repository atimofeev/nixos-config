{ pkgs, lib, osConfig, ... }: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;

      search = {
        force = true;
        default = "Google";
        engines = {

          "Google".metaData.alias = "g";

          "DuckDuckGo".metaData.alias = "ddg";

          "GitHub" = {
            definedAliases = [ "gh" ];
            urls =
              [{ template = "https://github.com/search?q={searchTerms}"; }];
            iconUpdateURL =
              "https://github.githubassets.com/favicons/favicon-dark.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "YouTube" = {
            definedAliases = [ "yt" ];
            urls = [{
              template =
                "https://www.youtube.com/results?search_query={searchTerms}";
            }];
            iconUpdateURL =
              "https://www.youtube.com/s/desktop/6b6081dd/img/favicon_32x32.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "NixOS Packages" = {
            definedAliases = [ "np" ];
            urls = [{
              template =
                "https://search.nixos.org/packages?query={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          "NixOS Options" = {
            definedAliases = [ "no" ];
            urls = [{
              template = "https://search.nixos.org/options?query={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          "NixOS Wiki" = {
            definedAliases = [ "nw" ];
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

        };
      };

      settings = let
        set = value: options:
          builtins.foldl' (opts: key: opts // { ${key} = value; }) { } options;
      in lib.attrsets.mergeAttrsList [

        # Pocket
        {
          "extensions.pocket.enabled" = false;
        }

        # Do not track
        {
          "privacy.donottrackheader.enabled" = true;
        }

        # Telemetry servers
        (set "0.0.0.0" [
          "toolkit.telemetry.dap_helper"
          "toolkit.telemetry.dap_leader"
          "toolkit.telemetry.server"
          "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint"
        ])

        # Surprising amount of telemetry flags
        (set false [
          "browser.newtabpage.activity-stream.feeds.telemetry"
          "browser.newtabpage.activity-stream.telemetry"
          "browser.ping-centre.telemetry"
          "browser.search.serpEventTelemetry.enabled"
          "dom.security.unexpected_system_load_telemetry_enabled"
          "network.trr.confirmation_telemetry_enabled"
          "security.app_menu.recordEventTelemetry"
          "security.certerrors.recordEventTelemetry"
          "security.protectionspopup.recordEventTelemetry"
          "toolkit.telemetry.archive.enabled"
          "toolkit.telemetry.bhrPing.enabled"
          "toolkit.telemetry.firstShutdownPing.enabled"
          "toolkit.telemetry.newProfilePing.enabled"
          "toolkit.telemetry.pioneer-new-studies-available"
          "toolkit.telemetry.reportingpolicy.firstRun"
          "toolkit.telemetry.shutdownPingSender.enabled"
          "toolkit.telemetry.unified"
          "toolkit.telemetry.updatePing.enabled"
        ])

        { "browser.toolbars.bookmarks.visibility" = "never"; }

        {
          "browser.startup.homepage" = "localhost:${
              toString osConfig.services.homepage-dashboard.listenPort
            }";
        }
        {
          "browser.uiCustomization.state" = # json
            ''
              {
                "placements": {
                  "widget-overflow-fixed-list": [],
                  "unified-extensions-area": [
                    "dearrow_ajay_app-browser-action",
                    "ublock0_raymondhill_net-browser-action",
                    "sponsorblocker_ajay_app-browser-action",
                    "_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action",
                    "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action",
                    "languagetool-webextension_languagetool_org-browser-action",
                    "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action",
                    "juraj_masiar_gmail_com_scrollanywhere-browser-action",
                    "_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action",
                    "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action"
                  ],
                  "nav-bar": [
                    "back-button",
                    "forward-button",
                    "stop-reload-button",
                    "home-button",
                    "customizableui-special-spring1",
                    "urlbar-container",
                    "customizableui-special-spring2",
                    "save-to-pocket-button",
                    "downloads-button",
                    "fxa-toolbar-menu-button",
                    "unified-extensions-button",
                    "addon_darkreader_org-browser-action"
                  ],
                  "toolbar-menubar": [
                    "menubar-items"
                  ],
                  "TabsToolbar": [
                    "tabbrowser-tabs",
                    "new-tab-button",
                    "alltabs-button"
                  ],
                  "PersonalToolbar": [
                    "import-button",
                    "personal-bookmarks"
                  ]
                },
                "seen": [
                  "developer-button",
                  "sponsorblocker_ajay_app-browser-action",
                  "addon_darkreader_org-browser-action",
                  "_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action",
                  "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action",
                  "languagetool-webextension_languagetool_org-browser-action",
                  "ublock0_raymondhill_net-browser-action",
                  "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action",
                  "dearrow_ajay_app-browser-action",
                  "juraj_masiar_gmail_com_scrollanywhere-browser-action",
                  "_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action",
                  "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action"
                ],
                "dirtyAreaCache": [
                  "nav-bar",
                  "PersonalToolbar",
                  "unified-extensions-area",
                  "TabsToolbar",
                  "toolbar-menubar"
                ],
                "currentVersion": 20,
                "newElementCount": 2
              }         
            '';
        }

      ];
    };
  };
}
