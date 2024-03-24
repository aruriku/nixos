{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
    unstable.resources
  ];
  environment.gnome.excludePackages = (with pkgs; [
  gnome-tour 
  gnome-console
   ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    totem
    gnome-music
  ]);
}
