{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../system/systemmodules.nix ];

  systemmodules = {
    virtualisation.enable = true;
    bluetooth.enable = true;
    hostname = "jczornik-gli";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/16b88d25-3b56-4e45-866d-0d0dbb5c30b4";
      preLVM = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.dates = "daily";

  # nix.gc.automatic = true;
  # nix.gc.dates = "daily";
  # nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  home-manager.backupFileExtension = "backup";

  users.users.jczornik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ font-awesome ubuntu_font_family roboto ];
    # fontconfig = {
    #   defaultFonts = {
    #     serif = [ "Ubuntu Serif" ];
    #     sansSerif = [ "Ubuntu" ];
    #     monospace = [ "Ubuntu Mono" ];
    #   };
    # };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;

  services.thinkfan = {
    enable = true;
    # extraArgs = [ "experimental" "1" ];
    levels = [
      [ "level auto" 0 3000 ]
      # [ 1 33 45 ]
      # [ 2 30 50 ]
      # [ 3 45 50 ]
      # [ 4 45 60 ]
      # [ 7 56 200 ]
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  environment.systemPackages = with pkgs; [
    modemmanager
    networkmanagerapplet
  ];

  # services.modemmanager.enable = true;

  networking.modemmanager.enable = true;

  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics = {
    enable = true;
    # enable32Bit = true; # Enable 32-bit DRI3 support
    # extraPackages = with pkgs; [
    #   intel-media-driver
    #   vaapiVdpau
    #   vaapiIntel
    #   mesa
    #   libvdpau-va-gl
    #   libva-utils
    # ];
  };

  hardware.nvidia.prime = {
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:45:0:0";
	};

  # environment.variables.EGL_PLATFORM = "nvidia";
  # environment.variables.EGL_PLATFORM_TYPE = "nvidia";

  # services.frigate.vaapiDriver = "nvidia";

  services.power-profiles-daemon.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
