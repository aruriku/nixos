#Standard GNOME config
{ pkgs, lib, config, ... }:
{
  # add some other core gnome apps
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
    resources
    gnomeExtensions.pip-on-top
    amberol
  ] ++ lib.optionals (config.networking.hostName == "kayoko") ([ # install only on laptop (stability reasons)
    gnomeExtensions.just-perfection
    gnomeExtensions.battery-health-charging]);
  # remove some default gnome apps that I don't personally use or want
  environment.gnome.excludePackages = (with pkgs; [
  gnome-tour 
  gnome-console
   ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    totem
    gnome-music
  ]);
  # install inter font (remove for 47(?)), enable with manually or use dconf.nix
  fonts.packages = with pkgs; [
  inter
  ];

  ##gnome configurations

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
