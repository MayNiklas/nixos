{ config, lib, pkgs, ... }: {

  networking = {

    firewall.allowedUDPPorts = [ 58104 ];

    interfaces.wg1 = { mtu = 1412; };

    wireguard.interfaces.wg1 = {

      ips = [ "172.20.1.1/24" "2a03:4000:003f:005d:8800::0/72" ];
      listenPort = 58104;
      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;

      peers = [
        {
          publicKey = "65Yiz6y4sWgmUkmAsxGYkwdb8yrwKQmAT3L9Hgz7whA=";
          allowedIPs = [ "172.20.1.2" "188.68.45.37/32" ];
        }
        {
          publicKey = "DWUsTmhpnFGWZH1gI4dX7rvfrw+kl5lMnRTpl0OzLxI=";
          allowedIPs = [ "172.20.1.3" "2a03:4000:003f:005d:8800::1" ];
        }
      ];

      postSetup = ''
        # expect packages with destination IP 188.68.45.37 on ens3
        ${pkgs.iproute2}/bin/ip neigh add proxy 188.68.45.37 dev ens3

        # expect packages with destination IP 2a03:4000:003f:005d:8800::1 on ens3
        ${pkgs.iproute2}/bin/ip neigh add proxy 2a03:4000:003f:005d:8800::1 dev ens3
      '';

      postShutdown = ''
        # expect packages with destination IP 188.68.45.37 on ens3
        ${pkgs.iproute2}/bin/ip neigh del proxy 188.68.45.37 dev ens3

        # expect packages with destination IP 2a03:4000:003f:005d:8800::1 on ens3
        ${pkgs.iproute2}/bin/ip neigh del proxy 2a03:4000:003f:005d:8800::1 dev ens3
      '';

    };
  };
}
