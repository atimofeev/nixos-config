{ pkgs, config, vars, ... }: {
  environment.systemPackages = with pkgs; [
    ansible
    sshpass # ssh auth with password
  ];

  # NOTE: waiting for paramiko 3.4.1 to remove warnings
  # https://nixpk.gs/pr-tracker.html?pr=336708
  nixpkgs.overlays = [
    (final: prev: {
      ansible = pkgs.unstable.ansible.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs
          ++ [ pkgs.unstable.python3Packages.hvac ];
      });
    })
  ];

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
