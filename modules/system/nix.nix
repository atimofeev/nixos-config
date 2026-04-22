{
  inputs,
  pkgs,
  ...
}:
{

  system = {
    activationScripts.diff = ''
      if [[ -e /run/current-system ]]; then
        ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
      fi
    '';
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      connect-timeout = 5;
      download-buffer-size = 524288000;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      fallback = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nix-cache.prosto.dev"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-cache.prosto.dev:fkJJVvqlmSQsfTTtdCrMUIg5f46+Aamve++PL3XEzNQ="
      ];
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  nixpkgs.config.allowUnfree = true;

}
