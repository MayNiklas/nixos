{ self, ... }: {

  mayniklas = {
    cloud.vmware-x86 = true;
    hosts = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    nix-common.disable-cache = true;
    metrics = {
      blackbox.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    sonarr.enable = true;
    jackett.enable = true;
    transmission = {
      enable = true;
      smb = true;
      port = 60343;
      web-port = 9091;
    };
  };

  networking = {
    hostName = "deke";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}

