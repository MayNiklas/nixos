{ config, pkgs, lib, ... }: {

  networking = {
    # Additional hosts to put in /etc/hosts
    extraHosts = ''
      # local
      192.168.5.1  unifi.local
      192.168.5.10 ds1819.local
      192.168.5.11 nuc8-i5-1.local
      192.168.5.12 nuc8-i5-2.local
      192.168.5.13 nuc8-i5-3.local
      192.168.5.14 the-bus.local
      192.168.5.15 vsphere.local
      192.168.5.64 water-on-fire.local
    '';
  };
}
