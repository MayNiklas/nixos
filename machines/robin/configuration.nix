{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  # services.netbox = {
  #   enable = true;
  #   dataDir = "/var/lib/netbox";
  #   listenAddress = "[::1]";
  #   port = 8001;
  #   secretKeyFile = "/var/src/secrets/netbox/key";
  # };

  networking = {
    hostName = "robin";
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c0c:6600::";
        prefixLength = 64;
      }];
    };
    # firewall = { allowedTCPPorts = [ 8001 ]; };
  };

  system.stateVersion = "22.05";

}
