# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, outputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      outputs.nixosModules.gnome
      inputs.home-manager.nixosModules.home-manager
    ];  
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      gambit = import ./home.nix;
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




  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking
  networking.hostName = "haruka"; # Define your hostname.
  networking.networkmanager = { 
	  enable = true;
  	insertNameservers = [ "192.168.2.183" "9.9.9.9" ]; # set dns servers
  };

  # enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    #deduplication
    auto-optimise-store = true;
  };


  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # Set your time zone.
  time.timeZone = "America/Moncton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gambit = {
    isNormalUser = true;
    description = "seb";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "gambit";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	vim
	wineWowPackages.waylandFull
	ffmpegthumbnailer
	firefox
  ];
   # removes xterm(don't need it)
  services.xserver.excludePackages = [ pkgs.xterm ];
  
    programs.steam = {
    enable = true;
    # fix gamescope hang https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
    #package = pkgs.steam.override {
    #  extraPkgs = pkgs: with pkgs; [
    #    xorg.libXcursor
    #    xorg.libXi
    #    xorg.libXinerama
    #    xorg.libXScrnSaver
    #    libpng
    #    libpulseaudio
    #    libvorbis
    #    stdenv.cc.cc.lib
    #    libkrb5
    #    keyutils
    #  ];
    #};
  };
  # enable gamescope  
  programs.gamescope.enable = true;
  #enable adb
  programs.adb.enable = true;
  
  #enable plymouth for graphical boot and shutdown
  boot.plymouth.enable = true;
  
  #custom font packages
  fonts.packages = with pkgs; [
	noto-fonts-cjk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  
  # enable oom killer
  services.earlyoom.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  # note from self: ^^ dont change it, not how you switch to a new ver or
  # to unstable. you did it through the channels command (now you do it from your flake)


}
