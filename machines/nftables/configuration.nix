{ self, ... }: {

  imports = [ ./wg0.nix ];

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "nftables";
    firewall = { enable = false; };
    nftables = {
      enable = true;
      ruleset = ''
        define WAN_IFC      = enp1s0
        define VPN_IFC      = wg0
        define VPN_NET      = 10.88.88.0/24

        table ip filter {
          
          chain INPUT {
            type filter hook input priority filter; policy accept;
            counter jump nixos-fw
            }
          
          chain nixos-drop {
            counter drop
            }

          chain nixos-fw-accept {
            counter accept
          }

          chain nixos-fw-refuse {
            counter drop
          }

          chain nixos-fw-log-refuse {
            meta l4proto tcp tcp flags & (fin|syn|rst|ack) == syn counter log prefix "refused connection: " level info
            pkttype != unicast counter jump nixos-fw-refuse
            counter jump nixos-fw-refuse
          }

          chain nixos-fw {
            iifname "lo" counter jump nixos-fw-accept
            ct state related,established counter jump nixos-fw-accept
            meta l4proto tcp tcp dport 22 counter jump nixos-fw-accept
            meta l4proto udp udp dport 58102 counter jump nixos-fw-accept
            meta l4proto icmp icmp type echo-request counter jump nixos-fw-accept
            counter jump nixos-fw-log-refuse
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
            
            # forward WireGuard traffic, allowing it to access internet via WAN
            iifname $VPN_IFC oifname $WAN_IFC ct state new accept
          }

          chain prerouting {
            type nat hook prerouting priority 0;
          }

          chain postrouting {
            type nat hook postrouting priority 100;

            # masquerade wireguard traffic
            # make wireguard traffic look like it comes from the server itself
            oifname $WAN_IFC ip saddr $VPN_NET masquerade
          }

        }
      '';
    };
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:1c1e:7352::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };

  system.stateVersion = "22.05";

}
