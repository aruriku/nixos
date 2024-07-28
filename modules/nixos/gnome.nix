#Standard GNOME config
{ pkgs, lib, config, home-manager, ... }:
{
  # add some other core gnome apps
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
    resources
    gnomeExtensions.pip-on-top
    amberol
  ] ++ lib.optionals (config.networking.hostName == "kayoko") ([ # install only on laptop (stability reasons)
    gnomeExtensions.just-perfection
    gnomeExtensions.battery-health-charging]);
  # remove some default gnome apps that I don't personally use or want
  environment.gnome.excludePackages = (with pkgs; [
  gnome-tour 
  gnome-console
   ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    totem
    gnome-music
  ]);
  # install inter font (remove for 47(?)), enable with manually or use dconf.nix
  fonts.packages = with pkgs; [
  inter
  ];

  ##gnome configurations

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #set home manager shared values for gnome configurations
  home-manager.sharedModules = [
    {
      # set gtk3 theme to adw-gtk3 to match libadwaita / modern GNOME
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
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
          #needs the Inter font installed!!!
          font-name = "Inter Variable 10.5";

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
        # enable gnome location services
        # P.S. broken until another GNOME point release or compiled with the option re-enabled 😭. Will need to manually set timezone or declare it in config until then.
        # https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/3032 & https://gitlab.gnome.org/GNOME/gnome-control-center/-/merge_requests/2540
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
    ];
}
