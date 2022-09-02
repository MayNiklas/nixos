{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.cloud.pve-x86;
in
{

  options.mayniklas.cloud.pve-x86 = {
    enable = mkEnableOption "activate pve-guest";
  };

  config = mkIf cfg.enable {

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    boot.growPartition = true;

    boot.loader.grub = {
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    # enable the qemu guest agent
    services.qemuGuest.enable = true;

  };
}
