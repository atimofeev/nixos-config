{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ terraform opentofu ];

  # Pin tofu version
  # FIX: golang build fails: conflict between vendor/modules.txt and go.mod requirements
  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     opentofu = pkgs.opentofu.overrideAttrs (oldAttrs: {
  #       version = "1.7.1";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "opentofu";
  #         repo = "opentofu";
  #         rev = "v1.7.1";
  #         sha256 = "sha256-201zceUedEl93nyglWJo0f9SDfFX31toP0MzzHQeJds=";
  #       };
  #     });
  #   };
  # };
}
