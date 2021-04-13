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
          publicKey = "l8IA2CW95sT+fURHmUkxmfpb78amqodNHUs5tk71xRM=";
          allowedIPs = [ "10.88.88.2/32" ];
        }
        {
          publicKey = "DiYQ6+0EvA6kG5w07I+y5GUp1Qxekj3txjgLmK9q3CI=";
          allowedIPs = [ "10.88.88.20/32" ];
        }
        {
          publicKey = "2x2O/fxtOjTJgKRxd3S/Z0jUFGw2S3etdqYTiBdHVwM=";
          allowedIPs = [ "10.88.88.21/32" ];
        }
        {
          publicKey = "pt5IcSnJdIKl12sNEZuV2vnR3qVQOuXASvd1OfWuZAU=";
          allowedIPs = [ "10.88.88.22/32" ];
        }
        {
          publicKey = "IG6shrAvupzelwaFBYDd476Xu9uUehoMYAcz80mGTGE=";
          allowedIPs = [ "10.88.88.23/32" ];
        }
      ];
    };
  };
}
