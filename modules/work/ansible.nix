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

    environment.systemPackages = with pkgs; [
      cfg.package
      sshpass # ssh auth with password
    ];

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
            [inventory]
            enable_plugins = aws_ec2, ini, yaml
          '';
      };

      custom-hm.user.shellAliases = {
        ansible-root = ''ansible --extra-vars "ansible_user=root"'';
        ansible-playbook-root = ''ansible-playbook --extra-vars "ansible_user=root"'';
      };

    };

  };

}
