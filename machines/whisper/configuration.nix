{ self, ... }: {

  services.nginx.virtualHosts = {
    "whisper.nik-ste.de" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            allow 10.88.88.0/24;
            allow 192.168.5.0/24;
            deny all;
          '';
        };
      };
    };
  };

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    docker.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
    metrics = {
      node = {
        enable = true;
        flake = true;
      };
    };
    nginx.enable = true;
  };

  networking = {
    hostName = "whisper";
    firewall.allowedTCPPorts = [ 80 443 ];
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c0c:a29f::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    interfaces.wg0 = { mtu = 1412; };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.88.88.17/24" ];
        privateKeyFile = toString /var/src/secrets/wireguard/private;
        generatePrivateKeyFile = true;
        peers = [
          {
            allowedIPs = [
              "10.88.88.1/32"
              "10.88.88.2/32"
              "10.88.88.20/32"
              "10.88.88.21/32"
              "10.88.88.22/32"
              "10.88.88.23/32"
              "10.88.88.24/32"
              "192.168.5.0/24"
            ];
            endpoint = "wg.nik-ste.de:58102";
            publicKey = "vpXKrLE0M7eH3GVd1I/OrfMRYQrq+TapUYfGyV1D4SQ=";
            persistentKeepalive = 15;
          }
        ];
      };
    };
  };

  system.stateVersion = "22.05";

}












