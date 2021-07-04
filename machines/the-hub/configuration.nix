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
    kvm-guest.enable = true;
    wg = {
      enable = true;
      server = true;
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

    wireguard.interfaces.wg0.peers = [
      # S2S home
      {
        publicKey = "lgEYddHkOxjEVqgnQruhwsRa/riiGm1jgcInDtCjfiU=";
        allowedIPs = [
          "10.88.88.2/32"
          "192.168.5.0/24"
          "192.168.15.0/24"
          "192.168.20.0/24"
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
        publicKey = "ffd7LTN66FX269qTyDxT2e4kfuo7b5cRQruUzneVOzs=";
        allowedIPs = [ "10.88.88.5/32" "192.168.98.0/24" ];
      }
      # S2S K.
      {
        publicKey = "x6r6/fKy1Yq2jqf0MngnpEJ6dPa/elf3nYPmNJ+5Myc=";
        allowedIPs = [ "10.88.88.6/32" "192.168.22.0/24" ];
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
    ];
  };

  system.stateVersion = "20.09";

}

