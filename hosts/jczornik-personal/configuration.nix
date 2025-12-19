{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../system/systemmodules.nix ];

  systemmodules = {
    virtualisation.enable = true;
    bluetooth.enable = true;
    hostname = "jczornik-personal";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ font-awesome ubuntu-classic roboto ];
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
    extraArgs = [ "experimental" "1" ];
    levels = [
      [ 0 0 35 ]
      [ 1 33 45 ]
      [ 2 40 50 ]
      [ 3 45 55 ]
      [ 4 50 60 ]
      [ 7 56 200 ]
    ];
  };

  services.power-profiles-daemon.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
