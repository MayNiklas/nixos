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
        192.168.5.12 nuc8-i5-2
        192.168.5.13 nuc8-i5-3
        192.168.5.14 the-bus
        192.168.5.15 vsphere
        192.168.5.20 aida
        192.168.5.21 kora
        192.168.5.64 water-on-fire
        192.168.20.5 bob
        192.168.20.10 simmons
        192.168.20.50 flint
        192.168.20.25 enoch
        192.168.30.95 snowflake
        192.168.30.99 deke

        # local
        192.168.5.1  unifi.local
        192.168.5.10 ds1819.local
        192.168.5.12 nuc8-i5-2.local
        192.168.5.13 nuc8-i5-3.local
        192.168.5.14 the-bus.local
        192.168.5.15 vsphere.local
        192.168.5.20 aida.local
        192.168.5.21 kora.local
        192.168.5.64 water-on-fire.local
        
        # wg
        10.88.88.1 status.nik-ste.de
        10.88.88.24 desktop

        192.168.88.70 chris

        # external
        5.181.49.14 the-hub
        37.120.177.174 the-bus
      '';
    };

  };
}
