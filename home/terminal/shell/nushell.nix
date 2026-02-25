{ pkgs, ... }:
{

  # TODO: learn nu https://www.nushell.sh/book/getting_started.html
  # TODO: configure https://www.nushell.sh/book/configuration.html
  # TODO: add plugins https://search.nixos.org/packages?channel=25.11&query=nushellPlugins
  # https://github.com/stars/atimofeev/lists/nushell

  # FIX: kubie prompt breaks nushell
  home.file."kubie.yaml" = {
    text = # yaml
      ''
        prompt:
          disable: true
      '';
    target = ".kube/kubie.yaml";
  };

  programs = {
    nushell = {
      enable = true;
      extraConfig = # nu
        ''
          $env.config = {
            show_banner: false,
            render_right_prompt_on_last_line: false,
            completions: {
              case_sensitive: false
              quick: true
              partial: true
              algorithm: "fuzzy"
            }           
          }

          plugin add ${pkgs.nushellPlugins.query}/bin/nu_plugin_query
        '';
    };
  };

}
