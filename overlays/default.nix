# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # fix gamescope hang https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
    steam = prev.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
    
    # GNOME 45 VRR PATCHES
    # can be removed for gnome 46
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
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
