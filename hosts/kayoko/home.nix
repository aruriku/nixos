# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    outputs.homeManagerModules.bash
    outputs.homeManagerModules.mpv
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.easyeffects
    outputs.homeManagerModules.fastfetch
    outputs.homeManagerModules.sops
    outputs.homeManagerModules.dev
    outputs.homeManagerModules.displayphone
  ];

  sops = {
    secrets.ssh-kayoko = {
      path = "${config.home.homeDirectory}/.ssh/kayoko";
      mode = "0600";
    };
  };
  # make this portable based on hostname at some point, and move it to shell.nix for readability
  programs.ssh = {
    matchBlocks = {
      "*" = lib.hm.dag.entryAfter ["aru"] {
        identityFile = "~/.ssh/kayoko";
      };
    };
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "seb";
    homeDirectory = "/home/seb";
  };
  home.packages = with pkgs;  [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
     (nerdfonts.override { fonts = [ "SourceCodePro" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
	  element-desktop
	  switcheroo
	  scrcpy
	  lsd
	  imagemagick
	  yt-dlp
    joplin-desktop
    borgbackup
    pcsx2
    lutris
    gimp
    unstable.fractal
  ];

  programs.displayphone = {
    enable = true;
    height = 1200;
    width = 1920;
  };

  # Enable syncthing
  services.syncthing.enable = true;

  # dconf to shrink gnome panel
  dconf.settings = {
    "org/gnome/shell/extensions/just-perfection" = {
      panel-size = 24; # shrink panel size to 24 pixels
      panel-icon-size = 13; # to remove giant gaps between wifi, sound, battery, etc icons
    };
    "org/gnome/shell".enabled-extensions = [
      "Battery-Health-Charging@maniacx.github.com"
      "just-perfection-desktop@just-perfection"
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
