{ self, config, pkgs, nixpkgs-unstable, ... }: {

  imports = [

    "${nixpkgs-unstable}/nixos/modules/services/web-servers/authelia.nix"

    {
      nixpkgs.overlays = [
        (self: super: {
          authelia = nixpkgs-unstable.legacyPackages.${pkgs.system}.authelia;
        })
      ];
    }

  ];

  ### NOT WORKING YET ###
  services.authelia.instances = {
    main = {
      enable = true;
      package = pkgs.authelia;
      settings = {
        theme = "dark";
        server = {
          host = "0.0.0.0";
          port = 9091;
        };
      };
      secrets = {
        storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
        jwtSecretFile = "/etc/authelia/jwtSecretFile";
      };
    };
  };

  mayniklas = {
    cloud.hetzner-x86 = {
      enable = true;
      interface = "ens3";
      ipv6_address = "2a01:4f8:1c1c:80de::";
    };
    server = {
      enable = true;
      home-manager = true;
    };
  };

  networking = {
    hostName = "authelia";
  };

  system.stateVersion = "22.05";

}
