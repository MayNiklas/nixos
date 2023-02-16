{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.cloud.hetzner-x86;

in
{

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  options.mayniklas.cloud.hetzner-x86 = {
    enable = mkEnableOption "activate hetzner-x86";
    growPartition = mkEnableOption "activate partition grow on boot";
  };

  config = mkIf cfg.enable {

    # Filesystem
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = mkIf cfg.growPartition true;
    };

    # Use the GRUB 2 boot loader.
    boot = {
      loader = {
        grub.enable = true;
        grub.version = 2;
        grub.device = "/dev/sda";
        timeout = 0;
      };
      growPartition = mkIf cfg.growPartition true;
      kernelParams = [ "console=ttyS0" ];
      initrd.availableKernelModules =
        [ "ata_piix" "virtio_pci" "xhci_pci" "sd_mod" "sr_mod" ];
      initrd.kernelModules = [ ];
      kernelModules = [ ];
      extraModulePackages = [ ];
    };

    # swapfile
    swapDevices = [{
      device = "/var/swapfile";
      size = (1024 * 8);
    }];

  };
}
