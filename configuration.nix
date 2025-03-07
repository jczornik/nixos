{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

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

  networking.hostName = "jczornik-gli";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    # allowedTCPPortRanges = [
    #   { from = 1; to = 65535; }
    # ];
    # allowedUDPPortRanges = [
    #   { from = 1; to = 65535; }
    # ];
  };
  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.pipewire.wireplumber.extraConfig = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.libinput.enable = true;

  services.cron.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
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
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    pavucontrol
    htop
    killall
    kitty
    docker-compose
    cifs-utils
    nfs-utils
    qemu
    sshfs
    hyprcursor
    bibata-cursors
    lm_sensors
    thinkfan
    power-profiles-daemon
    nh
  ];

  fonts.packages = with pkgs; [ font-awesome ubuntu_font_family roboto ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;
  programs.hyprland.enable = true;

  services.thinkfan = {
    enable = true;
    extraArgs = [
      "experimental"
      "1"
    ];
    levels = [
      [
        0
        0
        35
      ]
      [
        1
        33
        45
      ]
      [
        2
        40
        50
      ]
      [
        3
        45
        55
      ]
      [
        4
        50
        60
      ]
      [
        7
        56
        200
      ]
    ];
  };

  services.power-profiles-daemon.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
