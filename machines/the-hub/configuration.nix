{ self, ... }: {

  mayniklas = {
    server = {
      enable = true;
      home-manager = true;
    };
    iperf = { enable = true; };
    kvm-guest.enable = true;
    nginx.enable = true;
    metrics = {
      blackbox.enable = true;
      flake.enable = true;
      node.enable = true;
    };
    services.monitoring-server = {
      enable = true;
      loki = { enable = true; };
      dashboard = { enable = true; };
      nodeTargets = [
        "aida:9100"
        "bob:9100"
        "chris:9100"
        "deke:9100"
        "enoch:9100"
        "flint:9100"
        "kora:9100"
        "simmons:9100"
        "simone-pi4b:9100"
        "snowflake:9100"
        "quinjet:9100"
        "water-on-fire:9100"
        "the-bus:9100"
        "the-hub:9100"
        "lasse:9100"
        "10.88.88.2:9100"
      ];
      blackboxTargets = [
        "https://status.nik-ste.de"
        "https://lounge.rocks"
        "https://cache.lounge.rocks/nix-cache-info"
        "https://drone.lounge.rocks"
        "https://matrix.lounge.rocks/.well-known/matrix/client"
        "https://meet.lounge.rocks"
        "https://git.lounge.rocks"
      ];
      blackboxPingTargets = [
        "192.168.5.1"
        "192.168.22.1"
        "192.168.42.1"
        "192.168.88.1"
        "192.168.97.15"
        "192.168.98.1"
      ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "128m";
    recommendedProxySettings = true;

    # No need to support plain HTTP, forcing TLS for all vhosts. Certificates
    # provided by Let's Encrypt via ACME. Generation and renewal is automatic
    # if DNS is set up correctly for the (sub-)domains.
    virtualHosts = {
      # Graphana
      "status.nik-ste.de" = {
        forceSSL = true;
        enableACME = true;
        listen = [{
          addr = "10.88.88.1";
          port = 443;
          ssl = true;
        }];
        locations."/" = { proxyPass = "http://127.0.0.1:9005"; };
      };
    };
  };

  networking = {

    hostName = "the-hub";

    # Additional hosts to put in /etc/hosts
    extraHosts = ''
      #
      192.168.5.20 aida
      192.168.5.21 kora
      192.168.5.60 quinjet
      192.168.20.5 bob
      192.168.20.10 simmons
      192.168.20.50 flint
      192.168.20.111 lasse
      192.168.20.25 enoch
      192.168.30.95 snowflake
      192.168.30.99 deke

      # wg
      10.88.88.1 status.nik-ste.de
      10.88.88.8 simone-pi4b
      10.88.88.19 the-bus
      10.88.88.24 water-on-fire
      192.168.88.70 chris
    '';

    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a03:4000:3f:5d:98d5:41ff:feca:d0e7";
        prefixLength = 128;
      }];
    };

    firewall = {
      # only to renew certificate!
      # allowedTCPPorts = [ 80 443 ];
      interfaces.wg0.allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 58102 58103 58104 ];
    };

    interfaces = {
      wg0.mtu = 1412;
      wg1.mtu = 1412;
      wg2.mtu = 1412;
    };

    wireguard.interfaces.wg0 = {
      postSetup = ''
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.88.88.0/24 -o ens3 -j MASQUERADE
        # ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -A PREROUTING -d 5.181.49.14 -p tcp --dport 80 -j DNAT --to-destination 10.88.88.2
        # ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -A PREROUTING -d 5.181.49.14 -p tcp --dport 443 -j DNAT --to-destination 10.88.88.2
      '';

      postShutdown = ''
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.88.88.0/24 -o ens3 -j MASQUERADE
        # ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -D PREROUTING -d 5.181.49.14 -p tcp --dport 80 -j DNAT --to-destination 10.88.88.2
        # ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -D PREROUTING -d 5.181.49.14 -p tcp --dport 443 -j DNAT --to-destination 10.88.88.2
      '';
      ips = [ "10.88.88.1/24" ];
      listenPort = 58102;
      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;
      generatePrivateKeyFile = true;
      peers = [
        # S2S home
        {
          publicKey = "lgEYddHkOxjEVqgnQruhwsRa/riiGm1jgcInDtCjfiU=";
          allowedIPs = [
            "10.88.88.2/32"
            "192.168.5.0/24"
            "192.168.15.0/24"
            "192.168.20.0/24"
            "192.168.30.0/24"
          ];
        }
        # S2S G.
        {
          publicKey = "NeHl2LXjivsfYlBjfTz6fuMV/Wf/95j3Sb69WyKLrnI=";
          allowedIPs = [
            "10.88.88.3/32"
            "192.168.88.0/24"
            "192.168.99.0/24"
            "192.168.23.8/29"
          ];
        }
        # S2S M.
        {
          publicKey = "UxM4yRr6Vd5wYPtGcMcYd7pfyKZCGyz9VsG31FVbo38=";
          allowedIPs = [
            "10.88.88.4/32"
            "192.168.42.0/24"
            "192.168.52.0/24"
            "192.168.0.1/32"
          ];
        }
        # S2S Lep.
        {
          publicKey = "qGTvKWwkrdbaUvnTmkwvypWwmslKYitZ3h50F6JLFFM=";
          allowedIPs = [ "10.88.88.5/32" "192.168.98.0/24" ];
        }
        # S2S K.
        {
          publicKey = "x6r6/fKy1Yq2jqf0MngnpEJ6dPa/elf3nYPmNJ+5Myc=";
          allowedIPs = [ "10.88.88.6/32" "192.168.22.0/24" ];
        }
        # S2S A.
        {
          publicKey = "uYDIYQ1ZedQ4DZSESlAZogf3jynusk7g+UnI2ZfU01k=";
          allowedIPs = [ "10.88.88.7/32" "192.168.97.0/24" ];
        }
        # S2S S.
        {
          publicKey = "jvOx9hef7b9VWO0Lqv5BO7TtijxlxfIIQ9j0vwjZCn0=";
          allowedIPs = [ "10.88.88.8/32" ];
        }
        # iMac B.
        {
          publicKey = "fnuGuNVPco092ZV9zDNYY55tW/pzdRBltij9X/5DcUU=";
          allowedIPs = [ "10.88.88.9/32" ];
        }
        # the-bus
        {
          publicKey = "QugvtwQs3pvGMiXgHL80A0HrBhLwqQ+IXA0iH/M9BDk=";
          allowedIPs = [ "10.88.88.19/32" ];
        }
        # 13 inch MacBook Pro
        {
          publicKey = "DiYQ6+0EvA6kG5w07I+y5GUp1Qxekj3txjgLmK9q3CI=";
          allowedIPs = [ "10.88.88.20/32" ];
        }
        # 16 inch MacBook Pro
        {
          publicKey = "l8IA2CW95sT+fURHmUkxmfpb78amqodNHUs5tk71xRM=";
          allowedIPs = [ "10.88.88.21/32" ];
        }
        # 12.9 inch iPad Pro
        {
          publicKey = "pt5IcSnJdIKl12sNEZuV2vnR3qVQOuXASvd1OfWuZAU=";
          allowedIPs = [ "10.88.88.22/32" ];
        }
        # iPhone
        {
          publicKey = "IG6shrAvupzelwaFBYDd476Xu9uUehoMYAcz80mGTGE=";
          allowedIPs = [ "10.88.88.23/32" ];
        }
        # water-on-fire
        {
          publicKey = "dWMWrCKd/vTDhs+15YiFeSQziZACBiOK/f3vC5x73Qc=";
          allowedIPs = [ "10.88.88.24/32" ];
        }
        # MacBook A.
        {
          publicKey = "+UaFc1DRQIRgCU38G9qi7k2BiCUbIZVMYdYT/ZUyuCU=";
          allowedIPs = [ "10.88.88.200/32" ];
        }
        # Lukas Home
        {
          publicKey = "+Pw1XTLRbguc/HnAHMOl56ycQOozvSvLN6xaoAr2fQ8=";
          allowedIPs = [ "10.88.88.201/32" ];
        }
      ];
    };

    wireguard.interfaces.wg1 = {
      postSetup = ''
        # expect packages with destination IP 188.68.45.37 on ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iproute2}/bin/ip neigh add proxy 188.68.45.37 dev ens3

        # expect packages with destination IP 2a03:4000:003f:005d:8800::1 on ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iproute2}/bin/ip neigh add proxy 2a03:4000:003f:005d:8800::1 dev ens3
        # accept tcp packages with dport 5201 being forwarded to 2a03:4000:003f:005d:8800::1
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/ip6tables -A FORWARD --protocol tcp --destination-port 5201 --dst 2a03:4000:003f:005d:8800::1 --jump ACCEPT
        
        # drop all packages without active session being forwarded to 2a03:4000:003f:005d:8800::0/72
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/ip6tables -A FORWARD -m state --state NEW --dst 2a03:4000:003f:005d:8800::0/72 --jump DROP

        # drop packages into other wireguard networks
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 172.20.1.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 10.88.88.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 10.10.10.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst 192.168.5.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.5.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.15.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.20.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.30.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.88.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.99.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.42.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.52.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.98.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.22.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -A FORWARD --src 172.20.1.0/24 --dst "192.168.97.0/24" --jump DROP

        # NAT out packages 172.20.1.1/24 -> ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -A POSTROUTING -s 172.20.1.1/24 -o ens3 -j MASQUERADE
      '';

      postShutdown = ''
        # expect packages with destination IP 188.68.45.37 on ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iproute2}/bin/ip neigh del proxy 188.68.45.37 dev ens3
I
        # expect packages with destination IP 2a03:4000:003f:005d:8800::1 on ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iproute2}/bin/ip neigh del proxy 2a03:4000:003f:005d:8800::1 dev ens3
        # accept tcp packages with dport 5201 being forwarded to 2a03:4000:003f:005d:8800::1
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/ip6tables -D FORWARD --protocol tcp --destination-port 5201 --dst 2a03:4000:003f:005d:8800::1 --jump ACCEPT
        
        # drop all packages without active session being forwarded to 2a03:4000:003f:005d:8800::0/72
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/ip6tables -D FORWARD -m state --state NEW --dst 2a03:4000:003f:005d:8800::0/72 --jump DROP

        # drop packages into other wireguard networks
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 172.20.1.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 10.88.88.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 10.10.10.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst 192.168.5.0/24 --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.5.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.15.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.20.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.30.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.88.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.99.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.42.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.52.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.98.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.22.0/24" --jump DROP
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -D FORWARD --src 172.20.1.0/24 --dst "192.168.97.0/24" --jump DROP

        # NAT out packages 172.20.1.1/24 -> ens3
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -D POSTROUTING -s 172.20.1.1/24 -o ens3 -j MASQUERADE
      '';
      ips = [ "172.20.1.1/24" "2a03:4000:003f:005d:8800::0/72" ];
      # ips = [ "172.20.1.1/24" ];
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
    };

    wireguard.interfaces.wg2 = {
      postSetup = ''
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens3 -j MASQUERADE
      '';

      postShutdown = ''
        ${self.inputs.nixpkgs.legacyPackages.x86_64-linux.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o ens3 -j MASQUERADE
      '';
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
      ];
    };

  };

  # swapfile
  swapDevices = [{
    device = "/var/swapfile";
    size = (1024 * 2);
  }];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  system.stateVersion = "20.09";

}

