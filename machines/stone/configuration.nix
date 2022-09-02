{ pkgs, ... }: {

  mayniklas = {
    cloud.pve-x86.enable = true;
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

  # minecraft service
  systemd.services.minecraft-server = {
    description = "Minecraft Server Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.jre_headless}/bin/java \$@ -Xms2G -Xmx2G -jar /var/lib/minecraft/paper-1.19.2-132.jar --nogui";
      Restart = "always";
      User = "minecraft";
      WorkingDirectory = "/var/lib/minecraft";
    };
  };

  # minecraft user
  users.users.minecraft = {
    description = "Minecraft server service user";
    home = "/var/lib/minecraft";
    createHome = true;
    isSystemUser = true;
    group = "minecraft";
  };
  users.groups.minecraft = { };

  networking = {
    hostName = "stone";
    firewall = {
      allowedTCPPorts = [ 9100 9115 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
  };

  system.stateVersion = "20.09";

}
