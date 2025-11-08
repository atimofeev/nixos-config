{ inputs, ... }:
{

  imports = [ inputs.betterfox.homeModules.betterfox ];

  programs.firefox.betterfox = {
    enable = true;
    profiles.default = {
      settings = {
        fastfox.enable = true;
      };
    };
  };

}
