{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.wg;
in {

  options.mayniklas.wg = {
    enable = mkEnableOption "activate wireguard";
    server = mkEnableOption "activate wireguard server mode";
    router = mkEnableOption "activate wireguard router mode";
    ip = mkOption {
      type = types.str;
      default = "10.88.88.1";
      example = "10.88.88.20";
    };
    port = mkOption {
      type = types.int;
      default = 58102;
    };
    allowedIPs = mkOption {
      type = with types; listOf str;
      default = [ "10.88.88.0/24" ];
      description = ''
        List of IP (v4 or v6) addresses with CIDR masks from
        which this peer is allowed to send incoming traffic and to which
        outgoing traffic for this peer is directed. The catch-all 0.0.0.0/0 may
        be specified for matching all IPv4 addresses, and ::/0 may be specified
        for matching all IPv6 addresses.'';
    };
  };

  config = mkIf cfg.enable {

    networking.wireguard.interfaces.wg0 = {
      ips = [ "${cfg.ip}/24" ];
      listenPort = mkIf cfg.server cfg.port;

      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;
      generatePrivateKeyFile = true;

      peers = mkIf (cfg.server != true) [{

        publicKey = "vpXKrLE0M7eH3GVd1I/OrfMRYQrq+TapUYfGyV1D4SQ=";

        allowedIPs = cfg.allowedIPs;

        endpoint = "the-hub:58102";

        persistentKeepalive = 25;

      }];
    };

    # Enable ip forwarding, so wireguard peers can reach eachother
    boot.kernel.sysctl."net.ipv4.ip_forward" =
      mkIf cfg.server mkIf cfg.router 1;

    networking.firewall.allowedUDPPorts = mkIf cfg.server [ cfg.port ];

  };
}
