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
    transmission = {
      enable = true;
      port = 51413;
      web-port = 9091;
    };
    vmware-guest.enable = true;
  };

  networking.hostName = "deke";

  system.stateVersion = "20.09";

}

