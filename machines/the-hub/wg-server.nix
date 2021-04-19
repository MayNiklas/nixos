{ config, lib, pkgs, ... }: {

  networking.firewall.allowedUDPPorts = [ 58102 ];

  # Enable ip forwarding, so wireguard peers can reach eachother
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # enable NAT
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "ens3";
  # networking.nat.internalInterfaces = [ "wg0" ];

  # Enable Wireguard
  networking.wireguard.interfaces = {

    wg0 = {

      # Determines the IP address and subnet of the client's end of the
      # tunnel interface.
      ips = [ "10.88.88.1/24" ];

      listenPort = 58102;

      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;
      generatePrivateKeyFile = true;

      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.88.88.1/24 -o ens3 -j MASQUERADE
      # '';

      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.88.88.1/24 -o ens3 -j MASQUERADE
      # '';

      peers = [
        {
          publicKey = "dR4HocvCeIAq/+CmjfQxZ5lnPC9revbMSU1J7gB9Cl0=";
          allowedIPs = [
            "10.88.88.2/32"
            "192.168.5.0/24"
            "192.168.15.0/24"
            "192.168.20.0/24"
          ];
        }
        {
          publicKey = "NeHl2LXjivsfYlBjfTz6fuMV/Wf/95j3Sb69WyKLrnI=";
          allowedIPs = [
            "10.88.88.3/32"
            "192.168.88.0/24"
            "192.168.99.0/24"
            "192.168.23.8/29"
          ];
        }
        {
          publicKey = "m8X/POOpYspeCITzRKLWPQBl2jdKYine0XCAC8lVYCE=";
          allowedIPs = [ "10.88.88.4/32" "192.168.42.0/24" ];
        }
        {
          publicKey = "ffd7LTN66FX269qTyDxT2e4kfuo7b5cRQruUzneVOzs=";
          allowedIPs = [ "10.88.88.5/32" "192.168.98.0/24" ];
        }
        {
          publicKey = "x6r6/fKy1Yq2jqf0MngnpEJ6dPa/elf3nYPmNJ+5Myc=";
          allowedIPs = [ "10.88.88.6/32" "192.168.22.0/24" ];
        }
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
        {
          publicKey = "tY4kwJFserZZTHsfBzaQX05zFbPoPf90EYFQOmaE+zY=";
          allowedIPs = [ "10.88.88.150/32" ];
        }
      ];
    };
  };
}
