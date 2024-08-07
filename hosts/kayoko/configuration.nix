# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, outputs, ... }:

{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      outputs.nixosModules.gnome
      outputs.nixosModules.shared
      outputs.nixosModules.sshd
      outputs.nixosModules.waydroid
      inputs.home-manager.nixosModules.home-manager
      inputs.lanzaboote.nixosModules.lanzaboote # Secureboot support
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3 # Module for T14 specific changes (for now only enables amd pstate)
  ];  


  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      seb = import ./home.nix;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seb = {
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

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # networking
  networking.hostName = "kayoko"; # Define your hostname.
  networking.networkmanager = { 
	  enable = true;
  	insertNameservers = [ "192.168.2.183" "9.9.9.9" ]; # set dns servers
  };

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


  environment.systemPackages = with pkgs; [
	wineWowPackages.unstableFull
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
  
  # Enable various system programs
  programs = {
    steam.enable = true;
    steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescope.enable = true;
    gamescope.package = pkgs.unstable.gamescope; # Latest version fixes mouse offset with fractional scaling
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

  # Systemd service that runs alsactl restore on login to fix mic mute light.
  systemd.services.micFix = {
    after = [ "sound.target" "graphical.target" ];
    description = "Restore alsa to fix mic mute light";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${pkgs.alsa-utils}/bin/alsactl restore'';
    };
  };


  #custom font packages
  fonts.packages = with pkgs; [
	noto-fonts-cjk
  noto-fonts-cjk-serif
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

  # fix wireguard
  networking.firewall.checkReversePath = "loose";

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
