{ pkgs, lib, config, ... }: {
  imports = [ ./docker.nix ];

  options = {
    systemmodules.virtualisation.enable = lib.mkEnableOption "Enable virtualisation";
  };

  config = lib.mkIf config.systemmodules.virtualisation.enable {
    systemmodules.virtualisation.docker = {
      enable = lib.mkDefault true;
      storageDriver = "btrfs";
    };
  };
}
