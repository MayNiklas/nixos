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
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
}
