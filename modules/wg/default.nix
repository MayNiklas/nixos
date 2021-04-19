{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.wg;
in {

  options.mayniklas.wg = {
    enable = mkEnableOption "activate wireguard";
    server = mkEnableOption "activate server mode";
    ip = mkOption {
      type = types.str;
      default = "10.88.88.1";
      example = "10.88.88.20";
    };
    allowedIPs = mkOption {
      type = types.str;
      default = "10.88.88.0/24";
    };
  };

  config = mkIf cfg.enable {

    # Enable Wireguard
    networking.wireguard.interfaces = {

      wg0 = {

        # Determines the IP address and subnet of the client's end of the
        # tunnel interface.
        ips = [ "${cfg.ip}/24" ];

        # Path to the private key file
        privateKeyFile = toString /var/src/secrets/wireguard/private;
        generatePrivateKeyFile = true;

        peers = mkIf (cfg.server != true) [{

          publicKey = "vpXKrLE0M7eH3GVd1I/OrfMRYQrq+TapUYfGyV1D4SQ=";

          allowedIPs = [ "${cfg.allowedIPs}" ];

          endpoint = "the-hub:58102";

          persistentKeepalive = 25;

        }];

      };
    };
  };
}
