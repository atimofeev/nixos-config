_: {

  services.homepage-dashboard.widgets = [

    {
      datetime = {
        text_size = "x1";
        format = {
          hour12 = false;
          timeStyle = "short";
          dateStyle = "long";
        };
      };
    }

    {
      search = {
        provider = "google";
        target = "_blank";
      };
    }

    {
      resources = {
        label = "";
        cpu = true;
        memory = true;
        disk = [ "/" ];
      };
    }

    {
      openmeteo = {
        label = "Tbilisi";
        timezone = "Asia/Tbilisi";
        latitude = "41.697006";
        longitude = "44.798851";
        units = "metric";
      };
    }

  ];

}
