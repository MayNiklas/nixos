{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.vmware-guest;
in {

  options.mayniklas.vmware-guest = {
    enable = mkEnableOption "activate vmware-guest" // { default = true; };
  };

  config = mkIf cfg.enable {

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    boot.growPartition = true;

    boot.loader.grub = {
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    virtualisation.vmware.guest.enable = true;

  };
}
