{ self, ... }:

let
  interface = "ens3";
  subnet = "64";
  network = "2a03:4000:3f:5d::/${subnet}";
  own_ip = "2a03:4000:3f:5d:98d5:41ff:feca:d0e7/${subnet}";
in {

  imports = [ ./wg-server.nix ];

  mayniklas = {
    server = {
      enable = true;
      homeConfig = { imports = [ ../../home-manager/home-server.nix ]; };
    };
    kvm-guest.enable = true;
  };

  networking = {
    hostName = "the-hub";
    enableIPv6 = true;
    useDHCP = true;
    dhcpcd.persistent = true;
    dhcpcd.extraConfig = ''
      noipv6rs
      interface ${interface}
      ia_pd 1/${network} ${interface}
      static ip6_address=${own_ip}
    '';
  };

  system.stateVersion = "20.09";

}
