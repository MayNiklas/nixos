{ config, pkgs, lib, ... }: {

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Use the Grub2 as bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
    initrd.luks.devices = {
      root = {
        # Get UUID from blkid /dev/sda2
        device = "/dev/disk/by-uuid/ea8b02e5-d2ee-44f8-a056-c55fba0d5c93";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
}
