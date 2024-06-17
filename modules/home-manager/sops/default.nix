{ pkgs, inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
  home.packages = with pkgs; [
    sops
    age
  ];
  # add pub ssh key here for simplicity sake (at least for now)
  home.file = {
     "${config.home.homeDirectory}/.ssh/haruka.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjBdFWljP+aJMRRMZ+cwz27GmeXrRpLy0TAwT0PUi6/ haruka";
     "${config.home.homeDirectory}/.ssh/kayoko.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPep3/EQdG+cWb37JzpHQul3hKOhmnrJ7H3ujUqBxk/0 kayoko";
     "${config.home.homeDirectory}/.ssh/aru.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnlrEjuD+5ZcsU/yyHJwNlPFudFQd5DsODtKUEJnShn aru";
  };
}