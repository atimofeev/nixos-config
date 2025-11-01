{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.ansible;
in
{

  options.custom.work.ansible = {
    enable = lib.mkEnableOption "Ansible bundle";
    package = lib.mkPackageOption pkgs "ansible" { };
  };

  config = lib.mkIf cfg.enable {

    nixpkgs.config = {
      packageOverrides = pkgs: {
        ansible-w-plugins = cfg.package.overrideAttrs (oldAttrs: {
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
            pkgs.python3Packages.boto3
            pkgs.python3Packages.botocore
            pkgs.python3Packages.dnspython
            pkgs.python3Packages.hvac
          ];
        });
      };
    };

    environment.systemPackages = with pkgs; [
      ansible-w-plugins
      sshpass # ssh auth with password
    ];

    sops.secrets = {
      "work/env/VAULT_ADDR".owner = config.custom.hm-admin;
      "work/env/VAULT_TOKEN".owner = config.custom.hm-admin;
    };

    environment.shellInit = ''
      export VAULT_ADDR="$(cat ${config.sops.secrets."work/env/VAULT_ADDR".path})"
      export VAULT_TOKEN="$(cat ${config.sops.secrets."work/env/VAULT_TOKEN".path})"
    '';

    home-manager.users.${config.custom.hm-admin} = {

      home.file.".ansible.cfg" = {
        target = ".ansible.cfg";
        text = # conf
          ''
            [defaults]
            enable_plugins = aws_ec2, aws_ssm, yaml
            host_key_checking = false
            interpreter_python = auto_silent
            inventory = /home/${config.custom.hm-admin}/repos/betby/ansible/playbooks/inventories/prod/
            max_diff_size = 0
            private_key_file = =/home/${config.custom.hm-admin}/.ssh/id_ed25519
            [inventory]
            enable_plugins = aws_ec2, ini, yaml
          '';
      };

      programs.fish.shellAliases = {
        ansible = ''ansible --extra-vars "ansible_user=${config.custom.hm-admin}"'';
        ansible-root = ''ansible --extra-vars "ansible_user=root"'';
        ansible-playbook = ''ansible-playbook --extra-vars "ansible_user=${config.custom.hm-admin}"'';
        ansible-playbook-root = ''ansible-playbook --extra-vars "ansible_user=root"'';
      };

    };

  };

}
