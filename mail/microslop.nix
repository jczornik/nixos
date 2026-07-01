{ config, lib, pkgs, ... }:

{
  options.custom.mail.microslop.enable =
    lib.mkEnableOption "Enable microslop email proxy";

  config = lib.mkIf config.custom.mail.microslop.enable {
    services.davmail = {
      enable = true;
      settings = {
        "davmail.allowRemote" = false;
        "davmail.smtpSaveInSent" = true;
        "davmail.caldavAutoSchedule" = false;
        "davmail.imapPort" = 1143;
        "davmail.url" = "https://outlook.office365.com/EWS/Exchange.asmx";
        "davmail.mode" = "O365Manual";
      };
    };
  };
}
