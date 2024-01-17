{ pkgs, ... }: {
  # FIX: enable fish in sudo
  programs = {
    starship.enableFishIntegration = true;
    # FIX: not working
    fzf.enableFishIntegration = true;
    fish = {
      enable = true;
      # FIX: none of these are working properly
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z;
        }
        {
          name = "puffer-fish";
          src = pkgs.fishPlugins.puffer;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf;
        }
      ];
    };
  };
}
