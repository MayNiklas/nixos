{ config, lib, pkgs, adblock-unbound, ... }:
with lib;
let

  cfg = config.mayniklas.unbound;

  adlist = adblock-unbound.packages.${pkgs.system};

  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
    # DNS overwrites
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: "local-data: \"${n} A ${toString v}\"") cfg.A-records));

in
{

  options.mayniklas.unbound = {

    enable = mkEnableOption "unbound";

    A-records = mkOption {
      type = types.attrs;
      default = {
        "status.nik-ste.de" = "10.88.88.1";
        "nas.mh0.eu" = "192.168.42.10";
        "pass.telekom.de" = "109.237.176.33";
      };
      description = ''
        Custom DNS A records
      '';
    };

  };

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {

        server = {
          include = [
            "\"${dns-overwrites-config}\""
            "\"${adlist.unbound-adblockStevenBlack}\""
          ];
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
        domain-insecure = [ "haus" ];
        stub-zone = [
          {
            name = "haus";
            stub-addr = "10.88.88.4";
          }
        ];

        forward-zone = [
          {
            name = "google.*.";
            forward-addr = [
              "8.8.8.8@853#dns.google"
              "8.8.8.4@853#dns.google"
            ];
            forward-tls-upstream = "yes";
          }
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
