{ config, lib, pkgs, adblock-StevenBlack, ... }:
with lib;
let

  cfg = config.mayniklas.unbound;

  dns-overwrites-config = builtins.toFile "dns-overwrites.conf" (''
    # DNS overwrites
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: "local-data: \"${n} A ${toString v}\"") cfg.A-records));

  adblockStevenBlack = pkgs.stdenv.mkDerivation {
    name = "unbound-zones-adblock-StevenBlack";
    src = (adblock-StevenBlack + "/hosts");
    phases = [ "installPhase" ];
    installPhase = ''
      ${pkgs.gawk}/bin/awk '{sub(/\r$/,"")} {sub(/^127\.0\.0\.1/,"0.0.0.0")} BEGIN { OFS = "" } NF == 2 && $1 == "0.0.0.0" { print "local-zone: \"", $2, "\" static"}' $src | tr '[:upper:]' '[:lower:]' | sort -u >  $out
    '';
  };

in
{

  options.mayniklas.unbound = {

    enable = mkEnableOption "unbound";

    A-records = mkOption {
      type = types.attrs;
      default = {
        "status.nik-ste.de" = "10.88.88.1";
        "nas.mh0.eu" = "192.168.42.10";
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
            "\"${adblockStevenBlack}\""
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
