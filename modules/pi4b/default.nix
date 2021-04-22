{ lib, pkgs, config, modulesPath, ... }:
with lib;
let cfg = config.mayniklas.pi4b;
in {

  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  options.mayniklas.pi4b = {
    enable = mkEnableOption "hardware config for Raspberry Pi 4B";
  };

  config = mkIf cfg.enable {

    # Required for the Wireless firmware
    hardware.enableRedistributableFirmware = true;

    boot = {
      loader = {
        raspberryPi = {
          enable = true;
          version = 4;
        };
        # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
        grub.enable = false;
        # Enables the generation of /boot/extlinux/extlinux.conf
        generic-extlinux-compatible.enable = true;
      };

      kernelPackages = pkgs.linuxPackages_rpi4;
      initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
      initrd.kernelModules = [ ];
      kernelModules = [ ];
      extraModulePackages = [ ];
      tmpOnTmpfs = true;

      # ttyAMA0 is the serial console broken out to the GPIO
      kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        # Some gui programs need this
        "cma=128M"
      ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  };
}
