{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" ];
      kernelModules = [ ];
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2938deff-c6ef-4624-b7ad-a65029dab11c";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0E01-9111";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/762787e0-cd52-4f42-85df-917544269439"; }];

}
