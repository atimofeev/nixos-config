{ pkgs, ... }:
{

  programs.firefox = {

    profiles.default = {
      settings."xpinstall.signatures.required" = false; # allow custom extensions
      extensions = {
        force = true;
        settings = {
          "uBlock0@raymondhill.net" = {
            force = true;
            settings = {
              selectedFilterLists = [
                "easylist"
                "easylist-annoyances"
                "easylist-chat"
                "easylist-newsletters"
                "easylist-notifications"
                "easyprivacy"
                "fanboy-cookiemonster"
                "plowe-0"
                "ublock-badware"
                "ublock-cookies-easylist"
                "ublock-filters"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "urlhaus-1"
                "user-filters"
                "RUS-0"
                "RUS-1"
              ];
            };
          };
        };
      };
    };

    policies = {

      "3rdparty".Extensions = {
        "surfingkeys@brookhong.github.io" = {
          showAdvanced = true;
          snippets = builtins.readFile ./surfingkeys.js;
        };
        "addon@darkreader.org" = {
          syncSettings = false;
          enableForProtectedPages = true;
          theme = {
            mode = 1;
            brightness = 100;
            contrast = 100;
            grayscale = 0;
            sepia = 0;
            useFont = false;
            fontFamily = "Fira Code";
            textStroke = 0;
            engine = "dynamicTheme";
            stylesheet = "";
            darkSchemeBackgroundColor = "#1e1e2e";
            darkSchemeTextColor = "#cdd6f4";
            lightSchemeBackgroundColor = "#1e1e2e";
            lightSchemeTextColor = "#cdd6f4";
            scrollbarColor = "";
            selectionColor = "#585b70";
            styleSystemControls = true;
            darkColorScheme = "default";
            lightColorScheme = "default";
            immedateModify = false;
          };
          disabledFor =
            # (lib.importJSON inputs.self.packages.${pkgs.system}.catppuccin-userstyles-domains)
            # ++ [
            [
              "localhost:*"
              "configure.zsa.io"
              "en.wikipedia.org"
              "gemini.google.com"
              "github.com"
              "mail.google.com"
            ];
        };
      };

      ExtensionSettings = {
        "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
          # translate-web-pages
          default_area = "menubar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
          updates_disabled = false;
        };
        "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
          # catppuccin-mocha-lavender theme
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-lavender-git/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
          updates_disabled = false;
        };
        "addon@darkreader.org" = {
          default_area = "navbar";
          install_url = "file:///${pkgs.darkreader-declarative}/firefox.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
          updates_disabled = true;
        };
        "deArrow@ajay.app" = {
          default_area = "menubar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
          updates_disabled = false;
        };
        "idcac-pub@guus.ninja" = {
          default_area = "menubar";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          private_browsing = true;
          updates_disabled = false;
        };
        "languagetool-webextension@languagetool.org" = {
          default_area = "menubar";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool-webextension@languagetool.org/latest.xpi";
          private_browsing = true;
          updates_disabled = false;
        };
        "sponsorBlocker@ajay.app" = {
          default_area = "menubar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
          updates_disabled = false;
        };
        "surfingkeys@brookhong.github.io" = {
          default_area = "menubar";
          install_url = "file:///${pkgs.surfingkeys-declarative}/firefox.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
          updates_disabled = true;
        };
        "uBlock0@raymondhill.net" = {
          default_area = "menubar";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi";
          private_browsing = true;
          updates_disabled = false;
        };
      };

    };

  };

}
