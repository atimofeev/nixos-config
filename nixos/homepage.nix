{ vars, ... }: {
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8888;

    # TODO: figure out configuraiton

    # settings = {
    # title = "${vars.username} dashboard";
    #   # background = "";
    #   theme = "dark";
    #   # color = "zinc";
    #   # iconStyle = "theme";
    #   # statusStyle = "dot";
    #
    #   # target = "_blank"; # open links in new tabs
    #
    #   # hideVersion = true;
    #   # disableCollapse = true;
    # };
    # # services = "";
  };
}
