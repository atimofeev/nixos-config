{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    terraform
    opentofu
    tenv # https://github.com/tofuutils/tenv-nix#usage
  ];
}
