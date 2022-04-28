# nix build .#netcup-qcow2-image
# nix build 'github:MayNiklas/nixos'#netcup-qcow2-image
{ self, ... }: {

  mayniklas = {
    kvm-guest.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "netcup-x86";
    # interfaces.ens3 = {
    #   ipv6.addresses = [{
    #     address = "2a01:4f8:c0c:6600::";
    #     prefixLength = 64;
    #   }];
    # };
  };

  system.stateVersion = "22.05";

}
