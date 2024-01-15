{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # TODO: username, shell: use global variable
  # TODO: add sudo without pass
  programs.fish.enable = true;
  users.users.atimofeev = {
    isNormalUser = true;
    description = "atimofeev";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [ firefox ];
  };
}
