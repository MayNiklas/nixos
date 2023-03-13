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
      rootCredentialsFile = "/var/src/secrets/minio";
    };

    systemd.services.minio = mkIf cfg.storage-target {
      environment = {
        MINIO_SERVER_URL = "https://${cfg.domain}";
        MINIO_BROWSER_REDIRECT_URL = "https://minio.{cfg.domain}";
      };
    };

    networking = {
      firewall.checkReversePath = "loose";
      nameservers = [ "100.100.100.100" "1.1.1.1" ];

      firewall = {

        allowedTCPPorts = mkIf cfg.load-ballancer [ 80 443 ];

        interfaces = {

          ${config.services.tailscale.interfaceName} = {
            # minio storage targets should have ports 9000 & 9001 open via tailscale
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

        # Minio s3 backend
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

        # Minio admin console
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

    # we want to deploy from our nginx system -> dev purposes
    users.users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChYWn2XCh9VYr6DXibX9rLbnikafhZyviDvwfiKQ1m1WNy9sLkd5s3iK4kc1QFeN9y3Kw5oIeok1c6OmG9YsGJVwt/TooobFQiN0gzeBi5rEiFzBcaCPEbooL+n7Yu9/tq7j4bp28eqfzxtJquEQnXan/X1GOSusXcMI2YyCkQW29dX1YwDnftS9MR5KYky795yEwSa0VjpRm84RfzFN4bbS5sRKvWokODGh7hVF6wGXVrm2slnClRlvhOuLUvrKD2svCxH1mc0HW5CIuVK+1dDLlnNHy8Yhbr+iT+CMFRbBreIFK4htDYwRcxzOBmejZMRB7DfvKlkAl4Eca9/H7SrP/bALsP6PQdHqoCIfUhM/XQqRdmBw3hHsyIDqxIPMLqwCqSgyoRUFH/gBtla1AE1LTmV6TOpFFeDQ3DkGrwYyllJO+0qd/u9VcbDYm441K69nUsoXmURULCfKg+dCPly3Yf6aig4hXY6S7FQidvZpd2N8o9RQujoi0Osn8Lve0= nik@minio-hetzner-1"
        ];
      };
    };

  };
}
