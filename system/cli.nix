{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    killall
    kitty
    hyprcursor
    bibata-cursors
    lm_sensors
    thinkfan
    power-profiles-daemon
    nh
    gnumake
  ];
}
