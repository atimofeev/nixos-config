{ pkgs, ... }: {
  home.file."adwaita-hyprcursor" = let
    themeSource = pkgs.fetchFromGitHub {
      owner = "joaoalves03";
      repo = "adwaita-hyprcursor";
      rev = "3fc6c5435b75c104cf6a156960900506af622ab4";
      sha256 = "";
    } + "/hyprcursors";
  in {
    source = themeSource;
    target = ".local/share/icons/adwaita-hyprcursor";
  };

  wayland.windowManager.hyprland.settings = {
    env = [ "HYPRCURSOR_THEME,adwaita-hyprcursor" "HYPRCURSOR_SIZE,24" ];
  };
}
