{ self, ... }: {

  mayniklas = {
    cloud.vmware-x86.enable = true;
    hosts = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
  };

  networking = {
    hostName = "stone";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}
