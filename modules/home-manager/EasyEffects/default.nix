{ config, ... }: 
{

  services.easyeffects = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/easyeffects" = {
    source = ./easyeffects;
    recursive = true;
  };
}