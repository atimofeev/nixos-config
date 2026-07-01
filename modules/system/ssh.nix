{ pkgs, ... }:
{
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
  };
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
}
