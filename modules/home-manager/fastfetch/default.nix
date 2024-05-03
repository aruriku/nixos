{ config , ... }:
{
  home.file = {
    "${config.xdg.configHome}/fastfetch/fastfetch.jsonc".source = "./fastfetch.jsonc";
  };
}