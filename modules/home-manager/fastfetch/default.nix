{ config, pkgs, ... }:
{
  home.packages = [ pkgs.fastfetch ];
  home.file."${config.xdg.configHome}/fastfetch/config.jsonc" = {
    source = ./config.jsonc;
  };
  ##
}