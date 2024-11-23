_: {

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [ "${../../assets/dark-shore.png}" ];
      wallpaper = [ ",${../../assets/dark-shore.png}" ];
    };
  };

}
