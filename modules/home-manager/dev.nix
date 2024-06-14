{ config, pkgs, ...}:
{
  #Enable direnv for flakes support in vscode
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.vscode = with pkgs; {
    package = pkgs.unstable.vscode-fhsWithPackages (ps: with ps; [ go ]); # keep tracking unstable because of wayland ozone
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.jnoortheen.nix-ide #nix syntax support
      vscode-extensions.ms-vscode-remote.remote-ssh 
      vscode-extensions.mkhl.direnv #direnv support
    ];
  };
  programs.git = {
    enable = true; #usually already enabled
    userName = "aruriku";
    userEmail = "164705500+aruriku@users.noreply.github.com";
  };
  programs.git-credential-oauth.enable = true;
}