{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    nginx.enable = true;
  };

  networking = {
    hostName = "zammad-hetzner";
    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c2c:c669::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  system.stateVersion = "22.05";

}
