{ pkgs, config, vars, ... }: {
  environment.systemPackages = with pkgs; [
    ansible
    sshpass # ssh auth with password
  ];

  # Pin version
  nixpkgs.config = {
    packageOverrides = pkgs: {
      ansible = pkgs.ansible.overrideAttrs (oldAttrs: {
        # NOTE: broke with NixOS 24.05
        # version = "2.11.6";
        # src = pkgs.fetchFromGitHub {
        #   owner = "ansible";
        #   repo = "ansible";
        #   rev = "v2.11.6";
        #   sha256 = "sha256-+ljma9q1tDo0/0YQmjKO2R756BRydFgAu+2wDu+ARto=";
        # };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs
          ++ [ pkgs.python311Packages.hvac ];
      });
    };
  };

  sops.secrets = {
    "work/env/VAULT_ADDR".owner = vars.username;
    "work/env/VAULT_TOKEN".owner = vars.username;
  };

  environment.shellInit = ''
    export VAULT_ADDR="$(cat ${config.sops.secrets."work/env/VAULT_ADDR".path})"
    export VAULT_TOKEN="$(cat ${
      config.sops.secrets."work/env/VAULT_TOKEN".path
    })"
  '';

}
