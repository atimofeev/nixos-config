{

  imports = [
    ./extensions.nix
    ./policies.nix
    ./search.nix
    ./settings.nix
    ./user-content.nix
  ];

  programs.firefox = {
    enable = true;
    profiles.default.isDefault = true;
  };

}
