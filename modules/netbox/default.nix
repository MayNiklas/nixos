{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.netbox;
in
{

  options.mayniklas.netbox = {
    enable = mkEnableOption "activate netbox";
    hostname = mkOption {
      type = types.str;
      default = "netbox.your-domain.com";
      description = ''
        netbox url
      '';
    };
  };

  config = mkIf cfg.enable {

    services.netbox = {
      enable = true;
      dataDir = "/var/lib/netbox";
      listenAddress = "127.0.0.1";
      port = 8001;
      secretKeyFile = "/var/src/secrets/netbox/key";
    };

    services.nginx.virtualHosts = {
      "${cfg.hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/static/" = { alias = "/var/lib/netbox/static/"; };
          "/" = {
            proxyPass = "http://127.0.0.1:8001";
            extraConfig = ''
              proxy_set_header X-Forwarded-Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };

    users.groups.netbox.members = [ config.services.nginx.user ];

    networking.firewall = { allowedTCPPorts = [ 80 443 ]; };

    mayniklas.nginx.enable = true;

  };
}
