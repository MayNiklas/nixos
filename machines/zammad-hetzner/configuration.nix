{ self, ... }: {

  services.zammad = {
    enable = true;
    dataDir = "/var/lib/zammad";
    host = "127.0.0.1";
    openPorts = false;
    port = 3000;
    websocketPort = 6042;
    database.createLocally = true;
    # nix-shell -p openssl --run "openssl rand -hex 64 > /var/src/secrets/zammad/secret_key_base"
    secretKeyBaseFile = "/var/src/secrets/zammad/secret_key_base";
  };

  services.nginx.virtualHosts = {
    "zammad.lounge.rocks" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3000";
          #   extraConfig = ''
          #     proxy_set_header X-Forwarded-Host $http_host;
          #     proxy_set_header X-Real-IP $remote_addr;
          #     proxy_set_header X-Forwarded-Proto $scheme;
          #   '';
        };
      };
    };
  };

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    nginx.enable = true;
  };

  networking = {
    hostName = "zammad-hetzner";
    firewall.allowedTCPPorts = [ 80 443 ];
    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c2c:c669::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  system.stateVersion = "22.05";

}
