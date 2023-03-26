{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.keycloak;
in
{
  options.mayniklas.keycloak = {

    enable = mkEnableOption "activate keycloak";

    hostname = mkOption {
      type = types.str;
      default = "keycloak.lounge.rocks";
      description = ''
        keycloak url
      '';
    };

    port = mkOption {
      type = types.port;
      default = 10480;
      description = ''
        Port being used for connections between NGINX & keycloak
      '';
    };

  };
  config = mkIf cfg.enable {

    # Before enabling this module, you need to create a database password file:
    # sudo mkdir -p /var/src/secrets/keycloak
    # sudo touch /var/src/secrets/keycloak/db_passwordFile

    services.keycloak = {
      enable = true;
      database = {
        passwordFile = "/var/src/secrets/keycloak/db_passwordFile";
      };
      settings = {
        hostname = "${cfg.hostname}";
        http-relative-path = "";
        hostname-strict-backchannel = true;
        http-port = cfg.port;
        http-host = "127.0.0.1";
        proxy = "edge";
      };
    };

    services.nginx.virtualHosts = {
      "${cfg.hostname}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
              proxy_set_header X-Forwarded-Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };

  };
}
