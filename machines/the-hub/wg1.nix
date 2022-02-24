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
        # accept tcp packages with dport 5201 being forwarded to 2a03:4000:003f:005d:8800::1
        ${pkgs.iptables}/bin/ip6tables -A FORWARD --protocol tcp --destination-port 5201 --dst 2a03:4000:003f:005d:8800::1 --jump ACCEPT

        # drop all packages without active session being forwarded to 2a03:4000:003f:005d:8800::0/72
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -m state --state NEW --dst 2a03:4000:003f:005d:8800::0/72 --jump DROP

        # drop packages into other wireguard networks
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 172.20.1.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 10.88.88.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 10.10.10.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.5.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.15.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.20.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.30.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.88.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.99.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.42.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.52.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.98.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.22.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.97.0/24 --jump DROP

        # NAT out packages 172.20.1.1/24 -> ens3
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 172.20.1.1/24 -o ens3 -j MASQUERADE
      '';

      postShutdown = ''
        # expect packages with destination IP 188.68.45.37 on ens3
        ${pkgs.iproute2}/bin/ip neigh del proxy 188.68.45.37 dev ens3
          I
        # expect packages with destination IP 2a03:4000:003f:005d:8800::1 on ens3
        ${pkgs.iproute2}/bin/ip neigh del proxy 2a03:4000:003f:005d:8800::1 dev ens3
        # accept tcp packages with dport 5201 being forwarded to 2a03:4000:003f:005d:8800::1
        ${pkgs.iptables}/bin/ip6tables -D FORWARD --protocol tcp --destination-port 5201 --dst 2a03:4000:003f:005d:8800::1 --jump ACCEPT

        # drop all packages without active session being forwarded to 2a03:4000:003f:005d:8800::0/72
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -m state --state NEW --dst 2a03:4000:003f:005d:8800::0/72 --jump DROP

        # drop packages into other wireguard networks
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 172.20.1.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 10.88.88.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 10.10.10.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.5.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.15.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.20.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.30.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.88.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.99.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.42.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.52.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.98.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.22.0/24 --jump DROP
        ${pkgs.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.97.0/24 --jump DROP

        # NAT out packages 172.20.1.1/24 -> ens3
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 172.20.1.1/24 -o ens3 -j MASQUERADE
      '';

    };
  };
}
