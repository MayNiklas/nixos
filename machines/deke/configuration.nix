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
    sonarr.enable = true;
    jackett.enable = true;
    transmission = {
      enable = true;
      smb = true;
      port = 48678;
      web-port = 9091;
    };
  };

  networking = {
    hostName = "deke";
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  lollypops.deployment = {
    local-evaluation = true;
    ssh = { user = "root"; host = "192.168.30.99"; };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}

