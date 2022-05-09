{ self, ... }: {

  mayniklas = {
    cloud.vmware-x86 = true;
    hosts = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      blackbox.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    services = {
      minecraft-server = {
        enable = true;
        dataDir = "/var/lib/minecraft";
        declarative = true;
        eula = true;
        jvmOpts = "-Xms2048m -Xmx6656m";
        openFirewall = true;
        serverProperties = {
          difficulty = 2;
          gamemode = 0;
          max-players = 20;
          view-distance = 32;
          simulation-distance = 8;
          motd = "github.com/mayniklas";
          white-list = true;
        };
        whitelist = {
          JulianRooms = "a89ab984-6b22-4ba1-902a-8e44f65c6df7";
          BobderEhrenmann = "55df1dd6-8232-47f5-abbf-67c8f49ad26f";
          bobybest4ever = "3d58f395-1c80-46f2-b204-9aecf9651b9f";
          Fluxso587 = "f9e4dc1a-4eb8-4e6e-b583-86208294b50a";
          MushroomGHG = "d15eb1d5-876f-4c55-8b73-01b9449acdc2";
          Bloodwood_17 = "3e7f87ab-7165-4cb7-8176-4c788c2064ce";
          Magista18 = "aaac0fa1-2684-43d5-8b3a-55b9c1e3e11a";
        };
        ops = {
          BobderEhrenmann = {
            uuid = "55df1dd6-8232-47f5-abbf-67c8f49ad26f";
            level = 4;
            bypassesPlayerLimit = true;
          };
          JulianRooms = {
            uuid = "a89ab984-6b22-4ba1-902a-8e44f65c6df7";
            level = 4;
            bypassesPlayerLimit = true;
          };
        };
      };
    };
  };

  networking = {
    hostName = "flint";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  system.stateVersion = "21.11";

}
