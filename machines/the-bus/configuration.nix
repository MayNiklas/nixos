{ self, ... }: {

  mayniklas = {
    cloud.netcup-x86 = {
      enable = true;
      ipv6_address = "2a03:4000:6:8519::1";
    };
    kernel = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    matrix = {
      enable = true;
      host = "matrix.lounge.rocks";
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
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
  };

  system.stateVersion = "20.09";

}
