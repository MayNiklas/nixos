{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.matrix;
in {

  options.mayniklas.matrix = {
    enable = mkEnableOption "activate matrix";
    host = mkOption {
      type = types.str;
      default = "matrix.lounge.rocks";
      description = ''
        fqnd for Matrix homeserver.
      '';
    };
  };

  config = mkIf cfg.enable {

    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';

    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "${cfg.host}" = {
          enableACME = true;
          forceSSL = true;

          locations."= /.well-known/matrix/server".extraConfig = let
            # use 443 instead of the default 8448 port to unite
            # the client-server and server-server port for simplicity
            server = { "m.server" = "${cfg.host}:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

          locations."= /.well-known/matrix/client".extraConfig = let
            client = {
              "m.homeserver" = { "base_url" = "https://${cfg.host}"; };
              "m.identity_server" = { "base_url" = "https://vector.im"; };
            };
            # ACAO required to allow element-web on any URL to request this json file
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';

          # Reverse proxy for Matrix client-server and server-server communication
          # Or do a redirect instead of the 404, or whatever is appropriate for you.
          # But do not put a Matrix Web client here! See the Element web section below.
          locations."/".extraConfig = ''
            return 404;
          '';

          # forward all Matrix API calls to the synapse Matrix homeserver
          locations."/_matrix" = {
            proxyPass = "http://[::1]:8008"; # without a trailing /
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = "${cfg.host}";
        enable_registration = false;
        listeners = [{
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = false;
          }];
        }];
      };
    };

    mayniklas.nginx.enable = true;

  };
}
