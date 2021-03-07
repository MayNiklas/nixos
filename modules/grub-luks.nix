{ config, pkgs, lib, ... }: {
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
        device = "/dev/disk/by-uuid/${config.uuid}";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
  options.uuid = lib.mkOption { type = lib.types.str; };
}
