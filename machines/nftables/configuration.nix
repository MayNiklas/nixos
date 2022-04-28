{ self, ... }: {

  imports = [ ./wg0.nix ];

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "nftables";
    firewall = { enable = false; };
    nftables = {
      enable = true;
      rulesetFile = ./ruleset.nft;
    };
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:1c1e:7352::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };

  system.stateVersion = "22.05";

}
