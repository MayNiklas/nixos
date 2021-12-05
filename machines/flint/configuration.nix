{ self, ... }: {

  mayniklas = {
    hosts = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      node.enable = true;
      blackbox.enable = true;
    };
    vmware-guest.enable = true;
    services = {
      minecraft-server = {
        enable = true;
        dataDir = "/var/lib/minecraft";
        declarative = true;
        eula = true;
        jvmOpts = "-Xms2048m -Xmx7168m";
        openFirewall = false;
        serverProperties = {
          difficulty = 2;
          gamemode = 0;
          max-players = 20;
          motd =
            "github.com/mayniklas";
          white-list = true;
        };
        whitelist = {
          JulianRooms = "a89ab984-6b22-4ba1-902a-8e44f65c6df7";
          BobderEhrenmann = "55df1dd6-8232-47f5-abbf-67c8f49ad26f";
        };
      };
    };
  };

  networking = {
    hostName = "flint";
    firewall = { allowedTCPPorts = [ 25565 ]; };
  };

  system.stateVersion = "21.11";

}
