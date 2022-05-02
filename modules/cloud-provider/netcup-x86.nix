{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.cloud.netcup-x86;

in {

  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    (mkRenamedOptionModule [ "mayniklas" "kvm-guest" ] [ "mayniklas" "cloud" "netcup-x86" ] )
  ];

  options.mayniklas.cloud.netcup-x86 = {
    enable = mkEnableOption "profile for netcup servers";
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
    boot.loader.timeout = 5;

  };

}
