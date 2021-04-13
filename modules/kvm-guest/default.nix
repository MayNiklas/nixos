{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.kvm-guest;

in {

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  options.mayniklas.kvm-guest = {
    enable = mkEnableOption "activate kvm-guest";
  };

  config = mkIf cfg.enable {

    services.qemuGuest.enable = true;

    # Basic VM settings
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/sda";
    boot.loader.timeout = 0;

  };

}

