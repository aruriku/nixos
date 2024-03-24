{ pkgs, ... }:
{
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
