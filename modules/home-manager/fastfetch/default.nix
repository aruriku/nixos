{ config, pkgs, ... }:
{
  home.packages = [ pkgs.fastfetch ];
  home.file."${config.xdg.configHome}/fastfetch/fastfetch.jsonc" = {
    source = ./fastfetch.jsonc;
  };
  ##
}