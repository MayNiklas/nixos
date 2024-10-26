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

  config = let
    fqdn = "${cfg.host}";
    baseUrl = "https://${fqdn}";
    clientConfig."m.homeserver".base_url = baseUrl;
    serverConfig."m.server" = "${fqdn}:443";
    mkWellKnown = data: ''
      default_type application/json;
      add_header Access-Control-Allow-Origin *;
      return 200 '${builtins.toJSON data}';
    '';
  in mkIf cfg.enable {

    # 1. get the path of the postgresql versions
    # > nix build --print-out-paths nixpkgs#postgresql_14
    # > nix build --print-out-paths nixpkgs#postgresql_15
    # 2. rebuild to the target postgresql version
    # 3. stop the postgresql service
    # > sudo systemctl stop postgresql.service
    # 4. Switch to postgres user:
    # > sudo su postgres
    # 5. run the pg_upgrade
    # pg_upgrade \
    #   --old-datadir "/var/lib/postgresql/14" \
    #   --new-datadir "/var/lib/postgresql/15" \
    #   --old-bindir "/nix/store/ki3srrjjzqalvh0hd9lmqavp5v9wr9jp-postgresql-14.9/bin" \
    #   --new-bindir "/nix/store/vx04ph23h5bg6r10161k3wmx9j9dfbik-postgresql-15.4/bin"

    # we lock the postgresql version to 15, because we don't want the server to just
    # stop working after a nixos-rebuild
    services.postgresql.package = pkgs.postgresql_15;

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

          locations."= /.well-known/matrix/server".extraConfig =
            mkWellKnown serverConfig;

          locations."= /.well-known/matrix/client".extraConfig =
            mkWellKnown clientConfig;

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
        public_baseurl = baseUrl;
        enable_registration = false;
        listeners = [{
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = true;
          }];
        }];
        # TODO: is this enough?
        turn_uris = [
          "turn:turn.matrix.org:3478?transport=udp"
          "turn:turn.matrix.org:3478?transport=tcp"
        ];
        turn_user_lifetime = "1h";
      };
    };

    mayniklas.nginx.enable = true;

  };
}
