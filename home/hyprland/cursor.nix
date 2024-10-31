{ pkgs, ... }: {

  home = {

    pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };

    file."adwaita-hyprcursor" = let
      themeSource = pkgs.fetchFromGitHub {
        owner = "joaoalves03";
        repo = "adwaita-hyprcursor";
        rev = "3fc6c5435b75c104cf6a156960900506af622ab4";
        sha256 = "sha256-4DQvZVXarkyNvLKCxP+j3VVG3+BjxcOno5NHRMamc5U=";
      } + "/hyprcursors";
    in {
      source = themeSource;
      target = ".local/share/icons/adwaita-hyprcursor";
    };

    packages = with pkgs; [ hyprcursor ];

    sessionVariables = {
      HYPRCURSOR_THEME = "adwaita-hyprcursor";
      HYPRCURSOR_SIZE = "24";
      XCURSOR_THEME = "adwaita";
      XCURSOR_SIZE = "24";
    };

  };

}
