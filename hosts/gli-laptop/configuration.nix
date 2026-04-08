{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../system/systemmodules.nix ];
  nixpkgs.config.permittedInsecurePackages = [
  ];

  systemmodules = {
    virtualisation.enable = true;
    bluetooth.enable = true;
    hostname = "jczornik-gli";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 30;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/16b88d25-3b56-4e45-866d-0d0dbb5c30b4";
      preLVM = true;
    };
  };

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  # services.rpcbind.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
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
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" "networkmanager" "firezone" ]; # Enable ‘sudo’ for the user.
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ font-awesome ubuntu-classic roboto dejavu_fonts nerd-fonts.symbols-only];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;
  services.firezone.gui-client = {
    enable = true;
    name = "jczonik-gli-client";
    allowedUsers = [ "jczornik" ];
  };

  services.thinkfan = {
    enable = true;
    levels = [
      [ "level auto" 0 3000 ]
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
    nfs-utils
  ];


  networking.modemmanager.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;


  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # sync.enable = true;
		  intelBusId = "PCI:0:2:0";
		  nvidiaBusId = "PCI:45:0:0";
	  };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # environment.sessionVariables = { LIBVA_DRIVER_NAME = "nvidia"; };
  services.frigate.vaapiDriver = "nvidia";

  # hardware.nvidia.

  # environment.variables.EGL_PLATFORM = "nvidia";
  # environment.variables.EGL_PLATFORM_TYPE = "nvidia";

  # services.frigate.vaapiDriver = "nvidia";

  services.power-profiles-daemon.enable = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = pkgs.fetchurl {
      url = "https://gruvbox-wallpapers.pages.dev/wallpapers/mix/1.jpg";
      hash = "sha256-24PfrrLDxLcjJIrPGj1/qoIBgsV8Xmv3YcjeTkwnYJg=";
    };
    fonts = {
      serif = {
        package = pkgs.ubuntu-classic;
        name = "Ubuntu Serif";
      };
      sansSerif = {
        package = pkgs.ubuntu-classic;
        name = "Ubuntu";
      };
      monospace = {
        package = pkgs.ubuntu-classic;
        name = "Ubuntu Mono";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = "*";
      niri = {
        # Use GTK for file pickers, but Gnome for screen sharing
        default = [ "gtk" "gnome" ];
        "org.freedesktop.impl.portal.Screencast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
      };
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
