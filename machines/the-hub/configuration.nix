{ self, pkgs, dyson-exporter, shelly-exporter, valorant-exporter, ... }: {

  imports = [
    ./wg0.nix
    ./wg1.nix
    ./wg2.nix
    ./unbound.nix
    dyson-exporter.nixosModules.default
    shelly-exporter.nixosModules.default
    valorant-exporter.nixosModules.default
  ];

  mayniklas.unbound = { enable = true; };

  services = {

    dyson-exporter = {
      enable = true;
      configure-prometheus = true;
      envfile = "/var/src/secrets/dyson-exporter/envfile";
    };

    shelly-exporter = {
      enable = true;
      configure-prometheus = true;
      targets = [
        "http://192.168.15.2"
        "http://192.168.15.3"
        "http://192.168.15.4"
        "http://192.168.15.5"
      ];
    };

    valorant-exporter = {
      enable = true;
      configure-prometheus = true;
      # syntax: 'username/tag'
      targets = [
        "mayniklas/niki"

        "slimegod/euw"

        "ImJonazz/EUW"

        "Mana Tee Jay/1306"
        "TeeJay/1306"
        "Un4JHINate/4444"
        "TJ1306/7950"

        "sleepyjxnnie/love"
      ];
    };

  };

  mayniklas = {
    cloud.netcup-x86.enable = true;
    kernel= { enable = true; };
    server = {
      enable = true;
      home-manager = true;
    };
    iperf = { enable = true; };
    nginx.enable = true;

    services.monitoring-server = {
      enable = true;
      loki = { enable = true; };
      grafana = {
        enable = true;
        nginx = true;
      };
    };

    metrics = {

      pve = {
        enable = true;
        configure-prometheus = true;
        targets = [ "192.168.5.11" ];
      };

      esphome.configure-prometheus = true;

      blackbox = {
        enable = true;
        configure-prometheus = true;
        blackboxPingTargets = [
          "192.168.5.1"
          "192.168.21.15"
          "192.168.21.55"
          "192.168.22.1"
          "192.168.42.1"
          "192.168.72.1"
          "192.168.87.1"
          "192.168.88.1"
          "192.168.97.1"
          "192.168.98.1"
        ];
        targets = [
          "https://status.nik-ste.de"
          "https://cache.lounge.rocks/nix-cache-info"
          "https://drone.lounge.rocks"
          "https://matrix.lounge.rocks/.well-known/matrix/client"
          "https://git.lounge.rocks"
          "https://jellyfin.pamiro.net"
        ];
      };

      node = {
        enable = true;
        flake = true;
        configure-prometheus = true;
        targets = [
          "aida:9100"
          "bob:9100"
          "chris:9100"
          "deke:9100"
          "flint:9100"
          "kora:9100"
          "simmons:9100"
          "simone-pi4b:9100"
          "bella-pi4b:9100"
          "snowflake:9100"
          "water-on-fire:9100"
          "the-bus:9100"
          "the-hub:9100"
          "lasse:9100"
          "10.88.88.2:9100"
        ];
      };


      nginx = {
        enable = true;
        configure-prometheus = true;
      };

      wireguard = {
        enable = true;
        configure-prometheus = true;
        listenAddress = "10.88.88.1";
      };

    };
  };

  networking = {

    hostName = "the-hub";

    # Additional hosts to put in /etc/hosts
    extraHosts = ''
      #
      192.168.5.20 aida
      192.168.5.21 kora
      192.168.20.5 bob
      192.168.20.10 simmons
      192.168.20.50 flint
      192.168.20.75 lasse
      192.168.30.95 snowflake
      192.168.30.99 deke

      # wg
      10.88.88.1 status.nik-ste.de
      10.88.88.8 simone-pi4b
      10.88.88.9 bella-pi4b
      10.88.88.19 the-bus
      10.88.88.24 water-on-fire
      192.168.88.70 chris
    '';

    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a03:4000:3f:5d:98d5:41ff:feca:d0e7";
        prefixLength = 128;
      }];
    };

    firewall = { enable = false; };
    nftables = {
      enable = true;
      rulesetFile = ./ruleset.nft;
    };

  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  # swapfile
  swapDevices = [{
    device = "/var/swapfile";
    size = (1024 * 1);
  }];

  system.stateVersion = "20.09";

}
