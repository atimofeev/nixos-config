{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.services.syncthing;
in
{

  options.custom-hm.services.syncthing = {
    enable = lib.mkEnableOption "syncthing bundle";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      settings = {
        options = {
          urAccepted = -1;
        };

        devices = {
          milaptop.id = "OMLCF55-CZON22Z-3IVO7WL-TRJ2RBF-EZIRIHI-LM6DLGC-H2RM22P-3N6GQQF";
          zefir.id = "OGKDC5I-ZWEPHMX-RIEGN72-EWF4ETK-NQ253V5-6AIDHNP-HKD7LRN-GAZOXAM";
          "Pixel 5a".id = "6TLETF7-HMGU76V-M5SN43R-ZCHPQX7-KDJGIHM-VVXHQ3H-BXWDFJN-7LPKRA3";
          steamdeck.id = "AIATXVS-TQHLJRC-TTJLPNX-V2X45YE-ZGRERKG-ITMJKMT-FBNPCQL-MMXAQQ4";
        };

        folders = {
          obsidian-vault = {
            path = "${config.home.homeDirectory}/repos/obsidian-vault";
            devices = [
              "milaptop"
              "zefir"
              "Pixel 5a"
            ];
            ignorePerms = true;
          };
          retrodeck = {
            path = "${config.home.homeDirectory}/retrodeck";
            devices = [
              "milaptop"
              "steamdeck"
              "zefir"
            ];
            ignorePerms = true;
          };
        };

      };
    };
  };

}
