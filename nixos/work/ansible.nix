{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ansible
    sshpass # ssh auth with password
  ];

  # Pin version
  nixpkgs.config = {
    packageOverrides = pkgs: {
      ansible = pkgs.ansible.overrideAttrs (oldAttrs: {
        version = "2.11.6";
        src = pkgs.fetchFromGitHub {
          owner = "ansible";
          repo = "ansible";
          rev = "v2.11.6";
          sha256 = "sha256-+ljma9q1tDo0/0YQmjKO2R756BRydFgAu+2wDu+ARto=";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs
          ++ [ pkgs.python311Packages.hvac ];
      });
    };
  };
}
