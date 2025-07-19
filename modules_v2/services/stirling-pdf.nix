# NOTE: expose port config & add it to homepage
{ lib, config, ... }:
let
  cfg = config.custom.services.stirling-pdf;
in
{

  options.custom.services.stirling-pdf = {
    enable = lib.mkEnableOption "stirling-pdf bundle";
  };

  config = lib.mkIf cfg.enable {
    services.stirling-pdf = {
      enable = true;
      environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
        SERVER_PORT = 8181;
      };
    };
  };

}
