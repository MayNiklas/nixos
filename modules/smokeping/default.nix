{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.smokeping;
in
{

  options.mayniklas.smokeping = {
    enable = mkEnableOption "activate smokeping";
    hostName = mkOption {
      type = types.str;
      default = "kora";
      description = "The hostname of the smokeping server";
    };
    domain = mkOption {
      type = types.str;
      default = "smokeping.lounge.rocks";
      description = "The domain of the smokeping server";
    };
  };

  config = mkIf cfg.enable {

    services.smokeping = {
      enable = true;
      hostName = cfg.hostName;

      probeConfig =
        let
          dnshostname = "nixos.org";
        in
        ''
          +FPing
          binary = ${config.security.wrapperDir}/fping

          +FPing6
          binary = ${config.security.wrapperDir}/fping
          protocol = 6

          +DNS
          binary = ${pkgs.dig}/bin/dig
          lookup = ${dnshostname}
          pings = 5
          step = 300
        '';

      targetConfig = ''
        probe = FPing

        menu = Top
        title = Network Latency Grapher
        remark = Welcome to the SmokePing website of WORKS Company. \
                Here you will learn all about the latency of our network.

        + InternetSites

        menu = Internet Sites
        title = Internet Sites

        ++ GoogleSearch_iPv4
        menu = Google IPv4
        title = google.com
        host = google.com

        ++ GoogleSearch_iPv6
        menu = Google IPv6
        probe = FPing6
        title = ipv6.google.com
        host = ipv6.google.com

        + PingProbes

        menu = Ping Probes
        title = Ping Probes

        ++ the-hub_iPv4
        menu = the-hub IPv4
        host = wg.nik-ste.de 

        ++ the-hub_iPv6
        menu = the-hub IPv6
        probe = FPing6
        host = wg.nik-ste.de

        + DNSProbes
        menu = DNS Probes
        title = DNS Probes
        probe = DNS

        ++ GoogleDNS1
        menu = Google DNS 1
        title = Google DNS 8.8.8.8
        host = 8.8.8.8

        ++ GoogleDNS2
        menu = Google DNS 2
        title = Google DNS 8.8.4.4
        host = 8.8.4.4

        ++ CloudflareDNS1
        menu = Cloudflare DNS 1
        title = Cloudflare DNS 1.1.1.1
        host = 1.1.1.1

        ++ CloudflareDNS2
        menu = Cloudflare DNS 2
        title = Cloudflare DNS 1.0.0.1
        host = 1.0.0.1
      '';
    };

    services.fcgiwrap = {
      enable = true;
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        root = "${pkgs.smokeping}/htdocs";
        extraConfig = ''
          index smokeping.fcgi;
          gzip off;
        '';
        locations."~ \\.fcgi$" = {
          extraConfig = ''
            fastcgi_intercept_errors on;
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME ${config.users.users.smokeping.home}/smokeping.fcgi;
            fastcgi_pass unix:/run/fcgiwrap.sock;
          '';
        };
        locations."/cache/" = {
          extraConfig = ''
            alias /var/lib/smokeping/cache/;
            gzip off;
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 ];

  };
}
