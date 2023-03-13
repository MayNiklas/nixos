{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.minio;
in
{

  options.mayniklas.minio = {
    enable = mkEnableOption "activate minio";
    load-ballancer = mkEnableOption "activate minio load ballancer";
    storage-target = mkEnableOption "activate minio storage target";

    domain = mkOption {
      type = types.str;
      default = "s3.my-fast.de";
      description = "Domain name for the minio service";
    };

  };

  config = mkIf cfg.enable {

    services.minio = mkIf cfg.storage-target {
      enable = true;
      listenAddress = "0.0.0.0:9000";
      consoleAddress = "0.0.0.0:9001";
      region = "eu-central-1";
      # file contains:
      # MINIO_ROOT_USER=
      # MINIO_ROOT_PASSWORD=
      rootCredentialsFile = "/var/src/secrets/minio";
    };

    systemd.services.minio = mkIf cfg.storage-target {
      environment = {
        MINIO_SERVER_URL = "https://${cfg.domain}";
        MINIO_BROWSER_REDIRECT_URL = "https://minio1.${cfg.domain}";
      };
    };

    networking = {

      firewall.checkReversePath = "loose";
      nameservers = [ "100.100.100.100" "1.1.1.1" ];

      firewall = {

        # minio load ballancer should have ports 80 & 443 open
        allowedTCPPorts =
          mkIf cfg.load-ballancer [ 80 443 ];

        interfaces = {

          # minio storage targets should have ports 9000 & 9001 open via tailscale
          ${config.services.tailscale.interfaceName} = {
            allowedTCPPorts =
              mkIf cfg.storage-target [ 9000 9001 ];
          };

        };
      };
    };

    mayniklas.nginx.enable = true;

    services.nginx = mkIf cfg.load-ballancer {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "128m";
      recommendedProxySettings = true;

      commonHttpConfig = lib.mkForce ''
        server_names_hash_bucket_size 128;
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 256;
      '';

      virtualHosts = {

        # TODO:
        # add minio-upstream group and use it in the locations
        # https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html#integrations-nginx-proxy

        # minio s3 backend
        "${cfg.domain}" = {
          addSSL = true;
          enableACME = true;
          extraConfig = ''
            # To allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # To disable buffering
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://minio-1:9000";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                # proxy_set_header Host $host;
                proxy_connect_timeout 300;
                # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                chunked_transfer_encoding off;
              '';
            };
          };
        };

        # minio admin console
        "minio.${cfg.domain}" = {
          addSSL = true;
          enableACME = true;
          extraConfig = ''
            # To allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # To disable buffering
            proxy_buffering off;
          '';
          locations = {
            "/" = {
              proxyPass = "http://minio-1:9001";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                # proxy_set_header Host $host;
                proxy_connect_timeout 300;
                # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                chunked_transfer_encoding off;
              '';
            };
          };
        };

      };
    };

    # we use tailscale for communication between the reverse proxy & storage targets
    # tailscale up to login
    services.tailscale = {
      enable = true;
      interfaceName = "tailscale0";
    };

  };
}
