{ pkgs, ... }:
{
  #vrr patch overlays for gnome 45.5
  nixpkgs.overlays = [ (final: prev: {
    # elements of pkgs.gnome must be taken from gfinal and gprev
    gnome = prev.gnome.overrideScope' (gfinal: gprev: {
      mutter = gprev.mutter.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [
          (prev.fetchpatch {
            url = "https://aur.archlinux.org/cgit/aur.git/plain/vrr.patch?h=mutter-vrr";
            sha256 = "h3Z3x/I8pvfUf3Na04y+lr1/WTbgAUVanRrLLKx3EW8=";
          })
      ];
      });
      gnome-control-center = gprev.gnome-control-center.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [
          (prev.fetchpatch {
            url = "https://aur.archlinux.org/cgit/aur.git/plain/734.patch?h=gnome-control-center-vrr";
            sha256 = "8FGPLTDWbPjY1ulVxJnWORmeCdWKvNKcv9OqOQ1k/bE=";
          })
        ];
      });
    });
  }) ];
  #add some other core gnome apps
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
    unstable.resources
  ];
  #gnome some default gnome apps that I don't personally use or want
  environment.gnome.excludePackages = (with pkgs; [
  gnome-tour 
  gnome-console
   ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    totem
    gnome-music
  ]);


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
