{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.grub-luks;
in
{

  options.mayniklas.grub-luks = {
    enable = mkEnableOption "grub lvm";
    uuid = mkOption {
      type = types.str;
      default = "NULL";
      description = ''
        The UUID of the encrypted root partition.
        Check with blkid /dev/sda2.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
        };
      };
      cleanTmpDir = true;
      initrd.luks.devices = {
        root = {
          # Get UUID from blkid /dev/sda2
          device = "/dev/disk/by-uuid/${cfg.uuid}";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
  };
}
