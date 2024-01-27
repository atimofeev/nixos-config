{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      #nvtop 
    ];
}
