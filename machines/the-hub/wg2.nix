{ config, lib, pkgs, ... }: {

  networking = {

    firewall.allowedUDPPorts = [ 58103 ];

    interfaces.wg2 = { mtu = 1412; };

    wireguard.interfaces.wg2 = {

      ips = [ "10.10.10.1/24" ];
      listenPort = 58103;
      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;

      peers = [
        # MacBook M.
        {
          publicKey = "ylprZ5gCugAxo1lkdbSWWDicVHd+Ul+2rz9ItuMJxxs=";
          allowedIPs = [ "10.10.10.7/32" ];
        }
        # iPad M.
        {
          publicKey = "tY4kwJFserZZTHsfBzaQX05zFbPoPf90EYFQOmaE+zY=";
          allowedIPs = [ "10.10.10.8/32" ];
        }
        # iPhone M.
        {
          publicKey = "VZr3sY7tBcv0ETaNI2a8gvwyH1OG3+Rq/pUKYz703XQ=";
          allowedIPs = [ "10.10.10.9/32" ];
        }
        # VM
        {
          publicKey = "ujNbYq05wK1g8lrUbqilyKHxJB7eiifYTvVumVNEznM=";
          allowedIPs = [ "10.10.10.10/32" ];
        }
      ];

    };
  };
}
