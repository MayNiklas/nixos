# playing arround with distrubuted minio using NixOS

{ self, ... }: {

  mayniklas = {
    minio = {
      enable = true;
      load-ballancer = true;
    };
    cloud.hetzner-x86.enable = true;
    server = {
      enable = true;
      home-manager = true;
    };
  };

  ### remove lines once server module got enabled
  mayniklas = {
    locale.enable = true;
    nix-common = { enable = true; };
    openssh.enable = true;
    zsh.enable = true;
  };


  networking = {
    hostName = "minio-nginx";
    interfaces.ens3 = {
      ipv6.addresses = [{
        address = "2a01:4f8:1c1b:c680::";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  system.stateVersion = "22.05";

}
