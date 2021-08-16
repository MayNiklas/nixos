{ self, ... }:

let
  interface = "ens3";
  subnet = "64";
  network = "2a03:4000:3f:5d::/${subnet}";
  own_ip = "2a03:4000:3f:5d:98d5:41ff:feca:d0e7/${subnet}";
in {

  mayniklas = {
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
    hosts = { enable = true; };
    kvm-guest.enable = true;
    nginx.enable = true;
    metrics = {
      node.enable = true;
      blackbox.enable = true;
    };
    wg = {
      enable = true;
      server = true;
    };
    services.monitoring-server = {
      enable = true;
      loki = { enable = true; };
      dashboard = { enable = true; };
      nodeTargets = [
        "aida:9100"
        "deke:9100"
        "enoch:9100"
        "kora:9100"
        "snowflake:9100"
        "water-on-fire:9100"
        "the-hub:9100"
        "10.88.88.2:9100"
      ];
      blackboxTargets = [
        "https://lounge.rocks"
        "https://drone.lounge.rocks"
        "https://meet.lounge.rocks"
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

    enableIPv6 = true;
    useDHCP = true;
    dhcpcd.persistent = true;
    dhcpcd.extraConfig = ''
      noipv6rs
      interface ${interface}
      ia_pd 1/${network} ${interface}
      static ip6_address=${own_ip}
    '';

    firewall = {
      # only to renew certificate!
      # allowedTCPPorts = [ 80 443 ];
      interfaces.wg0.allowedTCPPorts = [ 80 443 ];
    };

    wireguard.interfaces.wg0.peers = [
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
        allowedIPs = [ "10.88.88.4/32" "192.168.42.0/24" ];
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
      # iMac B.
      {
        publicKey = "fnuGuNVPco092ZV9zDNYY55tW/pzdRBltij9X/5DcUU=";
        allowedIPs = [ "10.88.88.9/32" ];
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
      # MacBook M.
      {
        publicKey = "tY4kwJFserZZTHsfBzaQX05zFbPoPf90EYFQOmaE+zY=";
        allowedIPs = [ "10.88.88.150/32" ];
      }
      # MacBook A.
      {
        publicKey = "+UaFc1DRQIRgCU38G9qi7k2BiCUbIZVMYdYT/ZUyuCU=";
        allowedIPs = [ "10.88.88.200/32" ];
      }
    ];
  };

  system.stateVersion = "20.09";

}

