{ config, pkgs, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.bash
    outputs.homeManagerModules.mpv
    outputs.homeManagerModules.dconf
  ];


  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gambit";
  home.homeDirectory = "/home/gambit";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
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
	  lutris
	  unstable.switcheroo
	  scrcpy
	  lsd
	  imagemagick
	  yt-dlp

    (writeShellScriptBin "displayphone" ''
      ADB_COMMAND_START="adb shell wm size 1440x2560"
      ADB_COMMAND_END="adb shell wm size 1080x2400"
      echo "Setting screen resolution and starting scrcpy..."
      $ADB_COMMAND_START
      scrcpy -b 30m &
      scrcpy_pid=$!
      wait $scrcpy_pid
      echo "scrcpy closed, restoring phone resolution..."
      $ADB_COMMAND_END
      '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gambit/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "vim";
  };
  

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.ssh.enable = true;
  
}
