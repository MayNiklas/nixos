{ self, lib, ... }: {

  mayniklas = {
    cloud.pve-x86.enable = true;
    hosts = { enable = true; };
    kernel = { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    nix-common.disable-cache = true;
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    # sonarr.enable = true;
    # jackett.enable = true;
    transmission = {
      enable = true;
      smb = true;
      port = 48677;
      web-port = 9091;
    };
  };

  networking = {
    hostName = "snowflake";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}

