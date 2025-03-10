{ pkgs, lib, config, ... }: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.pipewire.wireplumber.extraConfig = {
    "monitor.bluez.properties" = lib.mkIf config.systemmodules.bluetooth.enable {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
