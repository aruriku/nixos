# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
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
  };
}
