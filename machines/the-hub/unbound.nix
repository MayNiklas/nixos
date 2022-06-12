{ config, lib, pkgs, ... }: {

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "10.88.88.1" ];
        access-control = [
          "127.0.0.0/8 allow"
          "192.168.0.0/16 allow"
          "10.88.88.0/24 allow"
        ];
      };

      # forward local DNS requests via Wireguard
      domain-insecure = [ "local" "haus" ];
      stub-zone = [
        {
          name = "local";
          stub-addr = "10.88.88.2";
        }
        {
          name = "haus";
          stub-addr = "10.88.88.4";
        }
      ];

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
          forward-tls-upstream = "yes";
        }
      ];

    };
  };

}
