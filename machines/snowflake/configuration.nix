{ self, ... }: {

  mayniklas = {
    hosts = { enable = true; };
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    nix-common.disable-cache = true;
    metrics = {
      node.enable = true;
      blackbox.enable = true;
    };
    sonarr.enable = true;
    jackett.enable = true;
    transmission = {
      enable = true;
      smb = true;
      port = 57267;
      web-port = 9091;
    };
    vmware-guest.enable = true;
  };

  networking = {
    hostName = "snowflake";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}

