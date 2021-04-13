{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.hosts;
in {

  options.mayniklas.hosts = { enable = mkEnableOption "activate hosts"; };

  config = mkIf cfg.enable {

    networking = {
      # Additional hosts to put in /etc/hosts
      extraHosts = ''
        #
        192.168.5.1  unifi
        192.168.5.10 ds1819
        192.168.5.11 quinjet
        192.168.5.12 nuc8-i5-2
        192.168.5.13 nuc8-i5-3
        192.168.5.14 the-bus
        192.168.5.15 vsphere
        192.168.5.64 water-on-fire

        # local
        192.168.5.1  unifi.local
        192.168.5.10 ds1819.local
        192.168.5.11 quinjet.local
        192.168.5.12 nuc8-i5-2.local
        192.168.5.13 nuc8-i5-3.local
        192.168.5.14 the-bus.local
        192.168.5.15 vsphere.local
        192.168.5.64 water-on-fire.local

        # external
        5.181.49.14 the-hub
      '';
    };

  };
}
