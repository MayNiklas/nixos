{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.cloud.vmware-x86;
in {

  imports = [
    (mkRenamedOptionModule [ "mayniklas" "vmware-guest" ] [ "mayniklas" "cloud" "vmware-x86" ])
  ];

  options.mayniklas.cloud.vmware-x86 = {
    enable = mkEnableOption "activate vmware-guest";
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
