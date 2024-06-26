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
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate # Enable amd pstate driver
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


  # networking
  networking.hostName = "haruka"; # Define your hostname.
  networking.networkmanager = { 
	  enable = true;
  	insertNameservers = [ "192.168.2.183" "9.9.9.9" ]; # set dns servers
  };


  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	vim
	wineWowPackages.unstableFull
	ffmpegthumbnailer
	firefox
  ];
   
  # Enable and Configure Services
  services = {
    xserver = {
      # remove xterm(don't need it)
      excludePackages = [ pkgs.xterm ];
    };
    # Enable automatic login for the user.
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "seb";
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
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
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
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Enable graphical boot and shutdown
    plymouth.enable = true;
  };

  # Enable btrfs transparent compression
  # remove if not using btrfs anymore/change configuration
  fileSystems = {
  "/".options = [ "compress=zstd" ];
  "/home".options = [ "compress=zstd" ];
  "/nix".options = [ "compress=zstd" "noatime" ];
  };

  # Enable virtualization
  virtualisation.libvirtd.enable = true;

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
  #networking.firewall.allowedTCPPorts = [ ... ]; 
  #networking.firewall.allowedUDPPorts = [ ... ]; 

  # KDE Connect / GS Connect
  networking.firewall.allowedTCPPortRanges = [{
    from = 1714;
    to = 1764;
  }]; 
  networking.firewall.allowedUDPPortRanges = [{
    from = 1714;
    to = 1764;
  }]; 
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
