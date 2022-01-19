{ self, ... }: {

  mayniklas = {
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
    kvm-guest.enable = true;
  };

  networking.hostName = "the-bus";

  system.stateVersion = "20.09";

}
