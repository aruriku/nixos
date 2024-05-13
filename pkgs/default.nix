# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

# change to {pkgs, ...}: if needing to pass more than pkgs is ever needed
# also will need to change additions in overlays/default.nix to
# additions = final: _prev: import ../pkgs final.pkgs;
pkgs:
{
  # example = pkgs.callPackage ./example { };
  displayphone = pkgs.callPackage ./displayphone.nix { };
  
  # commented out until ffsubsync is in the stable repos
  # not gonna change to unstable to test
  #autosubsync-mpv = pkgs.callPackage ./autosubsync-mpv.nix { };
}
