{ lib, config, modulesPath, disko, ... }:
with lib;
let
  cfg = config.mayniklas.cloud-provider-default;
in
{
  imports = [
    disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    # provider specific modules
    ./netcup.nix
    ./proxmox.nix
  ];

  options.mayniklas.cloud-provider-default = {
    enable = mkEnableOption "cloud-provider";
    primaryDisk = mkOption {
      type = types.str;
      default = "/dev/sda";
      description = "The name of the primary disk";
    };
  };

  config = mkIf cfg.enable {

    # Running fstrim weekly is a good idea for VMs.
    # Empty blocks are returned to the host, which can then be used for other VMs.
    # It also reduces the size of the qcow2 image, which is good for backups.
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    # We want to standardize our partitions and bootloaders across all providers.
    # -> BIOS boot partition
    # -> EFI System Partition
    # -> NixOS root partition (ext4)
    disko.devices.disk.main = {
      type = "disk";
      device = cfg.primaryDisk;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            start = "0";
            end = "1M";
            flags = [ "bios_grub" ];
          }
          {
            name = "ESP";
            start = "1M";
            end = "512M";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "nixos";
            start = "512M";
            end = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };

    # During boot, resize the root partition to the size of the disk.
    # This makes upgrading the size of the vDisk easier.
    fileSystems."/".autoResize = true;
    boot.growPartition = true;

    boot.loader.grub = {
      devices = [ cfg.primaryDisk ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    boot.loader.timeout = 10;

    # Currently all our providers use KVM / QEMU
    services.qemuGuest.enable = true;

  };

}
