{
  inputs,
  pkgs,
  config,
  ...
}:
{

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    inherit (config.programs.firefox) policies;
    profiles.default = {
      isDefault = true;
      inherit (config.programs.firefox.profiles.default) settings;
    };
  };

}
