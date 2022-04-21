{ self, ... }: {

  mayniklas = {
    cloud.hetzner-x86.enable = true;
    # server = {
    #   enable = true;
    #   home-manager = true;
    # };
  };

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (self.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "174dbx0kkrfdfdjswdny25nf7phgcb9k8i6z3rqqcy9l24f8xcp3";
      })
    ];
  };

  networking = {
    hostName = "hetzner-x86";
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c0c:6600::";
        prefixLength = 64;
      }];
    };
  };

  system.stateVersion = "22.05";

}
