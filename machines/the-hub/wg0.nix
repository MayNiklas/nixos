{ config, lib, pkgs, ... }: {

  networking = {

    firewall = {
      allowedUDPPorts = [ 58102 ];
      interfaces.wg0.allowedTCPPorts = [ 80 443 ];
    };

    interfaces.wg0 = { mtu = 1412; };

    wireguard.interfaces.wg0 = {

      ips = [ "10.88.88.1/24" ];
      listenPort = 58102;
      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;

      peers = [

        ### S2S connections

        # S2S home
        {
          publicKey = "lgEYddHkOxjEVqgnQruhwsRa/riiGm1jgcInDtCjfiU=";
          allowedIPs = [
            "10.88.88.2/32"
            "192.168.5.0/24"
            "192.168.15.0/24"
            "192.168.20.0/24"
            "192.168.30.0/24"
            "192.168.199.0/24"
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
          allowedIPs = [ "10.88.88.7/32" ];
        }
        # S2S S.
        {
          publicKey = "AmA0/uMU6OB4AmBfCtcFMBBoqQHDCnvBI8Fn2pdmY0E=";
          allowedIPs = [ "10.88.88.8/32" "192.168.72.0/24" ];
        }
        # S2S B.
        {
          publicKey = "yxr6ZTmho6hbM7zNwWhxloZxmfv7ETthNYWsn6eNSC0=";
          allowedIPs = [ "10.88.88.9/32" "192.168.21.0/24" ];
        }
        # S2S A. pfSense
        {
          publicKey = "gCo7+rsUa21TMG4RK8UYeYLOtt8wxtFgtcdm49epRx4=";
          allowedIPs = [ "10.88.88.10/32" "192.168.97.0/24" ];
        }
        # S2S A. / O. pfSense
        {
          publicKey = "Bk93ocUWLtUO4sJYjWp7KdBb8V3X3oquVe5HXCWeelw=";
          allowedIPs = [ "10.88.88.11/32" "192.168.87.0/24" "192.168.86.0/24" ];
        }

        ### servers

        # gpu-server
        {
          publicKey = "HnWGjYLK8FHpzBI3GJIfXx7XPRIQNLormwcN3gElwUU=";
          allowedIPs = [ "10.88.88.17/32" ];
        }

        # zammad
        {
          publicKey = "utTQ7nXjFzvoelIM92mxwfBN/LplPidKrVgYN8GKTXw=";
          allowedIPs = [ "10.88.88.18/32" ];
        }

        # the-bus
        {
          publicKey = "QugvtwQs3pvGMiXgHL80A0HrBhLwqQ+IXA0iH/M9BDk=";
          allowedIPs = [ "10.88.88.19/32" ];
        }

        ### Nik

        # 14 inch MacBook Pro
        {
          publicKey = "Kt0KK/cBKoMn29IUoiMEMNTTHgAlrBhqVcVtq0J9x04=";
          allowedIPs = [ "10.88.88.20/32" ];
        }
        # 14 inch MacBook Pro -> when using P2P
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

        ### J.

        # # J. Thinkpad T15 G2
        # {
        #   publicKey = "";
        #   allowedIPs = [ "10.88.88.30/32" ];
        # }
        # J. iPad
        {
          publicKey = "wB2rMFT63MjRHfzmhbPLEZUCPc/K4OWXR2DdgOecxXQ=";
          allowedIPs = [ "10.88.88.31/32" ];
        }
        # # J. iPhone
        # {
        #   publicKey = "";
        #   allowedIPs = [ "10.88.88.32/32" ];
        # }

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
  };
}
