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
    transmission = {
      enable = true;
      smb = true;
      port = 60343;
      web-port = 9091;
    };
    vmware-guest.enable = true;
  };

  networking = {
    hostName = "deke";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}
