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
          view-distance = 16;
          motd = "github.com/mayniklas";
          white-list = true;
        };
        whitelist = {
          JulianRooms = "a89ab984-6b22-4ba1-902a-8e44f65c6df7";
          BobderEhrenmann = "55df1dd6-8232-47f5-abbf-67c8f49ad26f";
          bobybest4ever = "3d58f395-1c80-46f2-b204-9aecf9651b9f";
          Fluxso587 = "f9e4dc1a-4eb8-4e6e-b583-86208294b50a";
          MushroomGHG = "d15eb1d5-876f-4c55-8b73-01b9449acdc2";
          Ilusha = "ee3476c9-29a6-4c7a-8146-d66f6d6a78a2";
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
