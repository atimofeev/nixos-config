{
  lib,
  pkgs,
  config,
  vars,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ansible
    sshpass # ssh auth with password
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      # ansible = pkgs.ansible.overrideAttrs (oldAttrs: {
      ansible = pkgs.ansible_2_17.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          pkgs.python3Packages.boto3
          pkgs.python3Packages.botocore
          pkgs.python3Packages.dnspython
          pkgs.python3Packages.hvac
        ];
      });
    };
  };

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
      text = # conf
        ''
          [defaults]
          # enable_plugins = aws_ec2, aws_ssm
          inventory = /home/${vars.username}/repos/betby/ansible/playbooks/inventories/prod/hosts
          interpreter_python = auto_silent
          max_diff_size = 0
          # [inventory]
          # enable_plugins = ini, aws_ec2
        '';
      target = ".ansible.cfg";
    };

    programs.fish.shellAliases =
      let
        extra-vars = lib.concatStringsSep " " [
          "ansible_ssh_private_key_file=/home/${vars.username}/.ssh/id_ed25519"
          "ansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
        ];
      in
      {
        ansible = ''ansible --extra-vars "ansible_user=${vars.username} ${extra-vars}"'';
        ansible-root = ''ansible --extra-vars "ansible_user=root ${extra-vars}"'';
        ansible-playbook = ''ansible-playbook --extra-vars "ansible_user=${vars.username} ${extra-vars}"'';
        ansible-playbook-root = ''ansible-playbook --extra-vars "ansible_user=root ${extra-vars}"'';
      };
  };

}
