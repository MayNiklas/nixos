{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "keycloak-hetzner";
    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c012:f5ef::";
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
