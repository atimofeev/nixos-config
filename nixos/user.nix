{ pkgs, vars, ... }: {
  # TODO: add sudo without pass
  programs.fish.enable = true;
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.${vars.shell};
    packages = with pkgs; [ firefox ];
  };
}
