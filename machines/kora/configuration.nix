{ self, ... }: {

  mayniklas = {
    docker = { enable = true; };
    hosts = { enable = true; };
    in-stock-bot = { enable = false; };
    metrics = {
      blackbox.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    pihole = {
      enable = true;
      port = "8080";
    };
    plex-version-bot = { enable = true; };
    scene-extractor = { enable = true; };
    shelly-plug-s = { enable = true; };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    server = {
      enable = true;
      home-manager = true;
    };
    vmware-guest.enable = true;
    youtube-dl = { enable = true; };
  };

  mayniklas.services.owncast = {
    enable = false;
    port = 8989;
    openFirewall = true;
  };

  networking = {
    hostName = "kora";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "20.09";

}
