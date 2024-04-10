# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ... }:
{
  # example = pkgs.callPackage ./example { };
  displayphone = pkgs.callPackage ./displayphone.nix { };
  
  # commented out until ffsubsync is in the stable repos
  # not gonna change to unstable to test
  #autosubsync-mpv = pkgs.callPackage ./autosubsync-mpv.nix { };
}
