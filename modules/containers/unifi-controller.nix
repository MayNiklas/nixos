{ config, pkgs, lib, ... }:
with lib;
let cfg = config.mayniklas.container.unifi;
in
{

  options.mayniklas.container.unifi = {

    enable = mkEnableOption "UniFi Controller";

    acmeMail = mkOption {
      type = types.str;
      default = "acme@lounge-rocks.io";
      example = "acme@lounge-rocks.io";
      description = "Mail to use for ACME";
    };

    domain = mkOption {
      type = types.str;
      default = "unifi.lounge-rocks.io";
      example = "unifi.lounge-rocks.io";
      description = "(Sub-) domain for unifi.";
    };

    PUID = mkOption {
      type = types.str;
      default = "1000";
      example = "1000";
      description = "PUID to run the controller";
    };

    PGID = mkOption {
      type = types.str;
      default = "1000";
      example = "1000";
      description = "PGID to run the controller";
    };

    adminPort = mkOption {
      type = types.str;
      default = "8443";
      example = "8443";
      description = "Port that gets bind to localhost";
    };

    version = mkOption {
      type = types.str;
      default = "7.1.61";
      example = "7.1.61";
      description = ''
        Version (tag) of UniFi to run. See for options:
        https://hub.docker.com/r/linuxserver/unifi-controller/tags
      '';
    };

  };

  config =
    let
      Image = "linuxserver/unifi-controller:version-${cfg.version}";
      adminPort = "${cfg.adminPort}";
    in
    mkIf cfg.enable {

      # Open firewall ports
      networking.firewall = { allowedTCPPorts = [ 80 443 ]; };

      security.acme = {
        acceptTerms = true;
        certs = { ${cfg.domain}.email = "${cfg.acmeMail}"; };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          # UniFi Controller
          "${cfg.domain}" = {
            enableACME = true;
            forceSSL = true;
            extraConfig = ''
              client_max_body_size 0;
            '';
            locations."/" = {
              proxyPass = "https://127.0.0.1:${toString adminPort}";
            };
          };
        };
      };

      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          unifi-controller = {
            autoStart = true;
            image = Image;
            environment = {
              # Possible settings:
              # https://github.com/linuxserver/docker-unifi-controller#parameters
              PUID = "${cfg.PUID}";
              PGID = "${cfg.PGID}";
              MEM_LIMIT = "1024";
              MEM_STARTUP = "512";
            };
            ports = [
              "127.0.0.1:${toString adminPort}:8443" # web admin port
              "3478:3478/udp" # Unifi STUN port
              "8080:8080" # Required for device communication
            ];
            volumes = [ "/docker/unifi-controller/data:/config:rw" ];
          };
        };
      };

      # Redirect logs for all docker units to syslog
      systemd.services = {
        docker-unifi-controller.serviceConfig = {
          StandardOutput = lib.mkForce "journal";
          StandardError = lib.mkForce "journal";
        };
      };

    };
}
