# deploying a Netcup system via nix-anywhere:
# nix run github:numtide/nixos-anywhere -- --flake .#<host> root@<ip>

{ config, pkgs, lib, ... }:

with lib;
let cfg = config.mayniklas.cloud-provider-default.netcup;

in {

  options.mayniklas.cloud-provider-default.netcup = {
    enable = mkEnableOption "netcup configuration";
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
    ipv6_prefixLength = mkOption {
      type = types.int;
      default = 64;
      description = "IPv6 prefixLength";
    };
  };

  config = mkIf cfg.enable {

    # set cfg.ipv6_address to the IPv6 address of the server
    # set cfg.interface to the interface to use
    networking = {
      # services.dhcpcd service stopped soliciting or accepting IPv6 Router Advertisements on interfaces
      # that use static IPv6 addresses. If your network provides both IPv6 unique local addresses (ULA)
      # and globally unique addresses (GUA) through autoconfiguration with SLAAC, you must add the
      # parameter networking.dhcpcd.IPv6rs = true;
      # (https://nixos.org/manual/nixos/unstable/release-notes.html#sec-release-23.05)
      dhcpcd.IPv6rs = (mkIf (cfg.ipv6_address != "NONE" && cfg.ipv6_prefixLength != 64)) true;
      interfaces.${cfg.interface} = {
        ipv6.addresses = (mkIf (cfg.ipv6_address != "NONE")) [
          {
            address = "${cfg.ipv6_address}";
            prefixLength = cfg.ipv6_prefixLength;
          }
        ];
      };
    };


    mayniklas.cloud-provider-default = {
      # enable our base module that is common across all providers
      enable = true;
      # make sure VIRTIO disk driver is set
      primaryDisk = "/dev/vda";
    };

    # Bootloader
    boot.kernelParams = [ "console=ttyS0" ];

  };
}
