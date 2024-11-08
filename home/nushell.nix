_: {

  # TODO: learn nu https://www.nushell.sh/book/getting_started.html
  # TODO: configure https://www.nushell.sh/book/configuration.html

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
    zoxide.enableNushellIntegration = true;
    yazi.enableNushellIntegration = true;
    eza.enableNushellIntegration = true;
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    starship = {
      enableNushellIntegration = true;
      enableTransience = true;
    };
    nushell = {
      enable = true;
      extraConfig = # nu
        ''
          $env.config = {
            show_banner: false,
            render_right_prompt_on_last_line: false,
            # NOTE: no fuzzy completion https://github.com/nushell/nushell/issues/1275
            # completion_mode: "fuzzy",
            # completion_mode: "list",
            # completion_algorithm: fuzzy,
          }
        '';
    };
  };

}
