{ pkgs, lib, config, ... }: {

  imports = [ ./cron.nix ];

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    home.packages = with pkgs; [
      go
      gotools

      nix-init

      attic-client
    ];
  };

  # virtualisation.oci-containers = {
  #   containers = {
  #     influxdb = {
  #       autoStart = true;
  #       image = "influxdb:2.7.1-alpine";
  #       ports = [ "8086:8086" ];
  #     };
  #   };
  # };

  mayniklas = {
    cloud.pve-x86.enable = true;
    docker = { enable = true; };
    hosts = { enable = true; };
    iperf = {
      enable = true;
      openFirewall = true;
    };
    kernel = { enable = true; };
    librespeedtest = {
      enable = true;
      port = "8000";
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    server = {
      enable = true;
      home-manager = true;
    };
    # smokeping = { enable = true; };
  };

  mayniklas.services.owncast = {
    enable = false;
    port = 8989;
    openFirewall = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking = {
    hostName = "kora";
    dhcpcd.enable = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.5.21";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.5.1";
    nameservers = [ "192.168.5.1" "1.1.1.1" ];
    firewall = { allowedTCPPorts = [ 9100 9115 ]; };
  };

  lollypops.deployment = {
    local-evaluation = false;
    ssh = {
      user = "root";
      host = "192.168.5.21";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "20.09";

}
