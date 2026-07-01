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
  boot.loader.timeout = 5;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  # services.rpcbind.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
  };

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

  #services.thinkfan = {
  #  enable = true;
  #  levels = [
  #    [ 0  0  50 ]  # Fan off until 55°C
  #    [ 1  40 55 ]  # Level 1 kicks in at 55°C, drops back to 0 at 48°C
  #    [ 2  45 60 ]
  #    [ 3  50 65 ]
  #    [ 6  55 75 ]
  #    [ 7  60 80 ]
  #    [ "level full-speed" 78 32767 ] # Maximum effort
  #  ];
  #};

  services.openssh = {
    enable = false;
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
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

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

  system.stateVersion = "26.05"; # Did you read the comment?
}
