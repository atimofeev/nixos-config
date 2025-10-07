{
  lib,
  pkgs,
  config,
  vars,
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
      "work/env/VAULT_ADDR".owner = vars.username;
      "work/env/VAULT_TOKEN".owner = vars.username;
    };

    environment.shellInit = ''
      export VAULT_ADDR="$(cat ${config.sops.secrets."work/env/VAULT_ADDR".path})"
      export VAULT_TOKEN="$(cat ${config.sops.secrets."work/env/VAULT_TOKEN".path})"
    '';

    home-manager.users.${vars.username} = {

      home.file.".ansible.cfg" = {
        target = ".ansible.cfg";
        text = # conf
          ''
            [defaults]
            enable_plugins = aws_ec2, aws_ssm, yaml
            host_key_checking = false
            interpreter_python = auto_silent
            inventory = /home/${vars.username}/repos/betby/ansible/playbooks/inventories/prod/
            max_diff_size = 0
            private_key_file = =/home/${vars.username}/.ssh/id_ed25519
            [inventory]
            enable_plugins = aws_ec2, ini, yaml
          '';
      };

      programs.fish.shellAliases = {
        ansible = ''ansible --extra-vars "ansible_user=${vars.username}"'';
        ansible-root = ''ansible --extra-vars "ansible_user=root"'';
        ansible-playbook = ''ansible-playbook --extra-vars "ansible_user=${vars.username}"'';
        ansible-playbook-root = ''ansible-playbook --extra-vars "ansible_user=root"'';
      };

    };

  };

}
