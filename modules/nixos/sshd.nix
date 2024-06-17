{ config, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    #knownHosts = {
     # haruka.publickeyFile = "/home/seb/.ssh/haruka.pub";
      #aru.publickeyFile = "/home/seb/.ssh/aru.pub";
      #kayoko.publickeyFile = "/home/seb/.ssh/kayoko.pub";
    #};
  };
    # would rather have this synced with the sops.nix but since they operate in different domains(homemanager vs system),
    # it'll have to be duplicated like this (for now)
    # maybe create a package that contains all keys and grab from that.
    users.users.seb.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjBdFWljP+aJMRRMZ+cwz27GmeXrRpLy0TAwT0PUi6/ haruka"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPep3/EQdG+cWb37JzpHQul3hKOhmnrJ7H3ujUqBxk/0 kayoko"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnlrEjuD+5ZcsU/yyHJwNlPFudFQd5DsODtKUEJnShn aru"
    ];
}