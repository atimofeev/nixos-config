{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    xremap.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      vars = import ./variables.nix;
    in
    {

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs vars; };
        modules = [
          ./nixos/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.xremap.nixosModules.default
        ];
      };

    };
}
