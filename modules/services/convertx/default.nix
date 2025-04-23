{

  virtualisation.oci-containers.containers.convertx = {
    image = "ghcr.io/c4illin/convertx";
    autoStart = true;
    environment = {
      HTTP_ALLOWED = "true";
      ALLOW_UNAUTHENTICATED = "true";
    };
    ports = [ "3000:3000" ];
    volumes = [ "convertx:/app/data" ];
  };

}
