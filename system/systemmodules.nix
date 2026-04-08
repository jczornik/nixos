{ pkgs, lib, config, inputs, ... }: {
  imports = [ ./sound.nix ./cli.nix ./virtualisation/module.nix ./remotefs/module.nix];

  options = {
    systemmodules = {
      bluetooth.enable = lib.mkEnableOption "Enable bluetooth services";
      hostname = lib.mkOption { type = lib.types.str; };
    };
  };

  config = {
    networking.hostName = config.systemmodules.hostname;
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
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
        };
      };
    };
    security.rtkit.enable = true;
    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    environment.systemPackages = [
      pkgs.tuigreet
    ];
  };
}
