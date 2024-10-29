_: {

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      preload = [ "${../../assets/dark-shore.png}" ];
      wallpaper = [ ",${../../assets/dark-shore.png}" ];
    };
  };

}
