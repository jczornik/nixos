{ pkgs, lib, config, inputs, ... }: {
  imports = [ ./sound.nix ./cli.nix ./virtualisation/module.nix ./remotefs/module.nix];

  options = {
    systemmodules = {
      bluetooth.enable = lib.mkEnableOption "Enable bluetooth services";
      hostname = lib.mkOption { type = lib.types.string; };
    };
  };

  config = {
    networking.hostName = options.systemmodules.hostname;
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
    security.rtkit.enable = true;
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
  };
}
