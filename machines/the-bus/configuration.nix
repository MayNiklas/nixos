{ self, ... }: {

  mayniklas = {
    cloud.netcup-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    matrix = {
      enable = true;
      host = "matrix.lounge.rocks";
    };
    metrics = {
      flake.enable = true;
      node.enable = true;
    };
    wg = {
      enable = true;
      ip = "10.88.88.19";
      allowedIPs = [ "10.88.88.1/32" ];
    };
    hosts = { enable = true; };
  };

  networking = {
    hostName = "the-bus";
    firewall.interfaces.wg0.allowedTCPPorts = [ 9100 ];
    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a03:4000:6:8519::1";
        prefixLength = 64;
      }];
    };
  };

  system.stateVersion = "20.09";

}
