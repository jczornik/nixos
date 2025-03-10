{ pkgs, lib, config, ... }:
let
  cfg = config.systemmodules.remotefs;
  sshfs = if cfg.sshfs.enable then [ pkgs.sshfs ] else [];
  nfs = if cfg.nfs then [ pkgs.nfs-utils ] else [];
  cifs = if cfg.cifs then [ pkgs.cifs-utils ] else [];
in
{
  options = {
    systemmodules.remotefs = {
      enable = lib.mkEnableOption "Enable remotefs module";
      sshfs.enable = lib.mkEnableOption "Install sshfs clinet utils";
      nfs.enable = lib.mkEnableOption "Install nfs clinet utils";
      cifs.enable = lib.mkEnbleOption "Install cifs clinet utils";
    };
  };
    config = lib.mkIf config.systemmodules.remotefs.enable {
      environment.systemPackages = sshfs ++ nfs ++ cifs;
    };
}
