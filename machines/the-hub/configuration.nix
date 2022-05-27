{ self, pkgs, ... }: {

  imports = [ ./wg0.nix ./wg1.nix ./wg2.nix ];

  mayniklas = {
    cloud.netcup-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    iperf = { enable = true; };
    nginx.enable = true;
    metrics = {
      blackbox.enable = true;
      json.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    services.monitoring-server = {
      enable = true;
      loki = { enable = true; };
      dashboard = { enable = true; };
      shellyTargets =
        [ "http://192.168.15.2/status" "http://192.168.15.3/status" ];
      nodeTargets = [
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
      blackboxTargets = [
        "https://status.nik-ste.de"
        "https://lounge.rocks"
        "https://cache.lounge.rocks/nix-cache-info"
        "https://drone.lounge.rocks"
        "https://matrix.lounge.rocks/.well-known/matrix/client"
        "https://meet.lounge.rocks"
        "https://git.lounge.rocks"
      ];
      blackboxPingTargets = [
        "192.168.5.1"
        "192.168.21.15"
        "192.168.22.1"
        "192.168.42.1"
        "192.168.72.1"
        "192.168.88.1"
        "192.168.97.1"
        "192.168.98.1"
      ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "128m";
    recommendedProxySettings = true;

    # No need to support plain HTTP, forcing TLS for all vhosts. Certificates
    # provided by Let's Encrypt via ACME. Generation and renewal is automatic
    # if DNS is set up correctly for the (sub-)domains.
    virtualHosts = {

      # Graphana
      "status.nik-ste.de" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          allow 10.88.88.0/24;
          allow 192.168.5.0/24;
          deny all; # deny all remaining ips
        '';
        locations."/" = { proxyPass = "http://127.0.0.1:9005"; };
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

