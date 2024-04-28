# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, outputs, ... }:

{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      outputs.nixosModules.gnome
      inputs.home-manager.nixosModules.home-manager
      inputs.lanzaboote.nixosModules.lanzaboote
  ];  


  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      sensei = import ./home.nix;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sensei = {
    isNormalUser = true;
    description = "seb";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
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


  # networking
  networking.hostName = "kayoko"; # Define your hostname.
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
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	vim
	wineWowPackages.waylandFull
	ffmpegthumbnailer
	firefox

  # for secure boot and tpm decryption support
  sbctl
  tpm2-tss
  ];
   
  # Enable and Configure Services
  services = {
    xserver = {
      # remove xterm(don't need it)
      excludePackages = [ pkgs.xterm ];
      # Enable automatic login for the user.
      #displayManager.autoLogin.enable = true;
      #displayManager.autoLogin.user = "sensei";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable EarlyOOM Out of Memory Killer
    earlyoom.enable = true;

    # Enable Pipewire
    pipewire = {
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

    # Enable firmware update
    fwupd.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable zram
  zramSwap.enable = true;
  
  # Enable various system programs
  programs = {
    steam.enable = true;
    gamescope.enable = true;
    # Enable adb for video streaming from phone using scrcpy
    adb.enable = true;
  };
   
  # Boot configuration
  boot = {
    # Configure bootloader
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;
    # Enable graphical boot and shutdown
    plymouth.enable = true;
    initrd.luks.devices."luks-90633d0f-30d4-4ccc-b28c-0457acba3f55".device = "/dev/disk/by-uuid/90633d0f-30d4-4ccc-b28c-0457acba3f55";
    # Enable secure boot capable bootloader
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    # Enable systemd in bootloader for tpm decryption
    initrd.systemd.enable = true;

    #fix hibernate
    resumeDevice = "/dev/mapper/luks-90633d0f-30d4-4ccc-b28c-0457acba3f55";
  };

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
