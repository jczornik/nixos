{ pkgs, lib, config, ... }: {
  imports = [ ./sound.nix ./cli.nix ./virtualisation/module.nix ./remotefs/module.nix];

  options = {
    systemmodules = {
      bluetooth.enable = lib.mkEnableOption "Enable bluetooth services";
    };
  };

  config = {
    networking.hostName = "jczornik-gli";
    networking.networkmanager.enable = true;
    networking.firewall = { enable = true; };
    time.timeZone = "Europe/Warsaw";

    i18n.defaultLocale = "en_US.UTF-8";

    hardware = lib.mkIf config.systemmodules.bluetooth.enable {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };
    services.blueman.enable =
      lib.mkIf config.systemmodules.bluetooth.enable true;

    services.libinput.enable = true;
    services.cron.enable = true;
  };
}
