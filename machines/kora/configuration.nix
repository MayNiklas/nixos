{ self, ... }: {

  mayniklas = {
    docker = { enable = true; };
    hosts = { enable = true; };
    in-stock-bot = { enable = true; };
    pihole = {
      enable = true;
      port = "8080";
    };
    plex-version-bot = { enable = true; };
    scene-extractor = { enable = true; };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    vmware-guest.enable = true;
    youtube-dl = { enable = true; };
  };

  networking.hostName = "kora";

  system.stateVersion = "20.09";

}
