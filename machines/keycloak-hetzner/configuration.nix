{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    nginx.enable = true;
    keycloak.enable = true;
  };

  networking = {
    hostName = "keycloak-hetzner";
    firewall.allowedTCPPorts = [ 80 443 ];
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
