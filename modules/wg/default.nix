{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.wg;
in
{

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

    networking = {

      # Cable internet: MTU of 1500
      # DSL & vDSL internet: MTU of 1492
      #
      # package overhead:
      #   8 bytes for UDP
      #   20 bytes for IPv4
      #   40 bytes for IPv6
      #   32 bytes for WireGuard
      #
      # when connecting to a Wireguard peer over IPv4, we have to subtract 20+8+32 = 60 bytes
      # when connecting to a Wireguard peer over IPv6, we have to subtract 40+8+32 = 80 bytes
      #
      # since we should always calculate the MTU for the worst case scenario,
      # we make the assumption that we are always connecting to a peer over IPv6 on VDSL:
      # 1492 - 80 = 1412
      #
      # Bigger MTU values are problematic, because they can cause fragmentation.
      # Fragmentation is a problem, because it can cause packet loss.
      # In some cases, a missconfigured MTU can cause weird problems on some services,
      # while others are working fine.
      #
      # The MTU of 1412 is a good compromise between performance and stability.
      # In some cases, it might be necessary to lower the MTU even further (NAT).
      interfaces.wg0 = { mtu = 1412; };


      wireguard.interfaces = {
        wg0 = {
          ips = [ "${cfg.ip}/24" ];
          listenPort = mkIf cfg.server cfg.port;

          # Path to the private key file
          privateKeyFile = "/var/src/secrets/wireguard/private";
          generatePrivateKeyFile = true;

          peers = mkIf (cfg.server != true) [{
            publicKey = "vpXKrLE0M7eH3GVd1I/OrfMRYQrq+TapUYfGyV1D4SQ=";
            allowedIPs = cfg.allowedIPs;
            endpoint = "the-hub:58102";
            persistentKeepalive = 15;
          }];
        };
      };

      firewall.allowedUDPPorts = mkIf cfg.server [ cfg.port ];

    };

    # Enable ip forwarding, so wireguard peers can reach eachother
    boot.kernel.sysctl."net.ipv4.ip_forward" = mkIf cfg.server 1;

  };
}
