{ inputs, ... }:
{

  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";
  };

}
