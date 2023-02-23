# nix build '.#usb-desktop-image'
{ self, lib, ... }: {

  imports = [
    ../../modules/user
    ../../modules/locale
    ../../modules/openssh
    ../../modules/zsh
  ];

  mayniklas = {
    user = {
      nik.enable = true;
      root.enable = true;
    };
    locale.enable = true;
    openssh.enable = true;
    zsh.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  boot = {
    growPartition = true;
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "uas" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = true;

  networking = {
    hostName = "usb-desktop";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "22.05";

}
