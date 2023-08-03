{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.cloud.pve-x86;
in
{

  options.mayniklas.cloud.pve-x86 = {
    enable = mkEnableOption "activate pve-guest";
    growPartition = mkEnableOption "activate partition grow on boot";
  };

  config = mkIf cfg.enable {

    # enable fstrim to reduce disk image size
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = mkIf cfg.growPartition true;
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
    boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

    boot.growPartition = mkIf cfg.growPartition true;

    boot.loader.grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    # enable the qemu guest agent
    services.qemuGuest.enable = true;

  };
}
