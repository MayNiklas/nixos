{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.cloud.hetzner-x86;

in
{

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  options.mayniklas.cloud.hetzner-x86 = {
    enable = mkEnableOption "activate hetzner-x86";
    growPartition = mkEnableOption "activate partition grow on boot";

    interface = mkOption {
      type = types.str;
      default = "ens3";
      description = "Interface to use";
    };
    ipv6_address = mkOption {
      type = types.str;
      default = "NONE";
      description = "IPv6 address of the server";
    };

  };

  config = mkIf cfg.enable {

    # set cfg.ipv6_address to the IPv6 address of the server
    # set cfg.interface to the interface to use
    networking = {
      interfaces.${cfg.interface} = {
        ipv6.addresses = (mkIf (cfg.ipv6_address != "NONE"))
          [
            {
              address = "${cfg.ipv6_address}";
              prefixLength = 64;
            }
          ];
      };
      defaultGateway6 = (mkIf (cfg.ipv6_address != "NONE")) {
        address = "fe80::1";
        interface = "${cfg.interface}";
      };
    };

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
