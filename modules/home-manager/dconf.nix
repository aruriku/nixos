# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  #TODO: move into gnome config (merge these two configs?)
  dconf.settings = {
    # custom keybinds
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ]; # change alt+f4 to super+q
      toggle-fullscreen = [ "<Control><Alt>Home" ]; # set a shortcut to fullscreen apps on demand
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true; # enable infinite workspaces
      edge-tiling = true; # enable side by side window snapping
      experimental-features = [ "variable-refresh-rate" "scale-monitor-framebuffer" ];
    };
    "org/gnome/desktop/interface" = {
      # set top bar time format
      clock-format = "12h";
      clock-show-weekday = false;
      # set my fonts to how I prefer it
      font-antialiasing = "grayscale";
      font-hinting = "slight";
    };
    "org/gnome/shell/extensions/Battery-Health-Charging" = {
      charging-mode = "bal";
      icon-style-type = 0;
      indicator-position-max = 4;
      show-battery-panel2 = false;
      show-notifications = false;
      show-preferences = true;
      show-quickmenu-subtitle = true;
      show-system-indicator = false;
    };
    "org/gnome/shell/extensions/pip-on-top" = {
      stick = true;
    };
    #enable gnome location services
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    # Extensions enabled for all machines
    "org/gnome/shell".enabled-extensions = [
      "pip-on-top@rafostar.github.com"
    ];
  };
}
