{ config, pkgs, lib, modulesPath, ... }:

with lib;
let cfg = config.mayniklas.cloud.netcup-x86;

in
{

  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    (mkRenamedOptionModule [ "mayniklas" "kvm-guest" ] [ "mayniklas" "cloud" "netcup-x86" ])
  ];

  options.mayniklas.cloud.netcup-x86 = {
    enable = mkEnableOption "profile for netcup servers";
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
    };

    services.qemuGuest.enable = true;

    # Basic VM settings
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = mkIf cfg.growPartition true;
    };



    boot.growPartition = mkIf cfg.growPartition true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/sda";
    boot.loader.timeout = 5;

    # config to fix the `no space left`
    # error during nix build
    fileSystems."/tmp" = {
      fsType = "tmpfs";
      device = "tmpfs";
      options = [ "nosuid" "nodev" "relatime" "size=2G" ];
    };
    boot.tmpOnTmpfs = false;
    services.logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

  };

}
