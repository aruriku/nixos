{ pkgs, inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets.ssh = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };
  };
  home.packages = with pkgs; [
    sops
  ];
  # add pub ssh key here for simplicity sake (at least for now)
  home.file = {
     "${config.home.homeDirectory}/.ssh/id_ed25519.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjBdFWljP+aJMRRMZ+cwz27GmeXrRpLy0TAwT0PUi6/ main";
  };
}