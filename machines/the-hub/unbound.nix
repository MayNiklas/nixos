{ config, lib, pkgs, ... }: with lib; let

  dns-overwrites = {
    "status.nik-ste.de" = "10.88.88.1";
    "nas.mh0.eu" = "192.168.42.10";
  };

  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
    # DNS overwrites
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: "local-data: \"${n} A ${toString v}\"") dns-overwrites));

in
{

  config = {
    services.unbound = {
      enable = true;
      settings = {

        server = {
          include = "\"${dns-overwrites-config}\"";
          interface = [
            "127.0.0.1"
            "10.10.10.1"
            "10.88.88.1"
          ];
          access-control = [
            "127.0.0.0/8 allow"
            "192.168.0.0/16 allow"
            "10.10.10.0/24 allow"
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
  };

}
