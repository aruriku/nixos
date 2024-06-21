{ config, pkgs, inputs, fetchFromGitHub, ... }:
{
  ## pkgs/waydroid-script/default.nix
  environment.systemPackages = [
    pkgs.waydroid-script
  ];
  virtualisation.waydroid.enable = true;
}