  # Shared configs between systems.
  { config, lib, inputs, pkgs, ... }:
  {
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Enable zram
  zramSwap.enable = true;

  # Install a standard set of command-line tools
  environment.systemPackages = with pkgs; [
    vim
    util-linux
    usbutils
    ncdu
  ];
  programs.mtr.enable = true;
}