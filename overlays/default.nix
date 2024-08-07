# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    
    steam = prev.steam.override {
      extraPkgs = pkgs: with pkgs; [
        # fix gamescope hang https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
        # fixed in commit https://github.com/NixOS/nixpkgs/commit/c75cffb303689012df35d68dcb9bffa9b64f5ad3, watch for it to enter stable
        libkrb5
        keyutils

        #install mangohud to steam
        mangohud
      ];
      
      # Old source 1 game fix
      # may need to add LD_PRELOAD=$LD_PRELOAD:/lib32/libtcmalloc_minimal.so %command% to game's launch options
      extraLibraries = pkgs: [ pkgs.gperftools ];
    };
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
