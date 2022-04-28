{ config, lib, pkgs, ... }: {
  networking = {

    interfaces.wg0 = { mtu = 1412; };

    wireguard.interfaces.wg0 = {

      ips = [ "10.88.88.1/24" ];
      listenPort = 58102;
      privateKeyFile = toString /var/src/secrets/wireguard/private;
      generatePrivateKeyFile = true;

      peers = [
        # MacBook Nik
        {
          publicKey = "l8IA2CW95sT+fURHmUkxmfpb78amqodNHUs5tk71xRM=";
          allowedIPs = [ "10.88.88.21/32" ];
        }
      ];
    };
  };
}
