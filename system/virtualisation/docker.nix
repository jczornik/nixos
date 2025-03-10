{ pkgs, lib, config, ... }: {
  options = {
    systemmodules.virtualisation.docker = {
        enable = lib.mkEnableOption "Install docker utils";
        storageDriver = lib.mkOption {
          type = lib.types.string;
          default = null;
          description = "Storage driver for docker";
        };
      };
  };

  config = lib.mkIf config.systemmodules.virtualisation.docker.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
