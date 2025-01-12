{ vars, ... }: {

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
        label = "Budva";
        timezone = vars.tz_name;
        latitude = "42.291070";
        longitude = "18.840169";
        units = "metric";
      };
    }

  ];

}
