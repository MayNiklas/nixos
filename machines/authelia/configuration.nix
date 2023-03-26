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
  # https://search.nixos.org/options?channel=unstable&query=services.authelia.
  ### NOT WORKING YET ###
  services.authelia.instances = {
    main = {
      enable = false;
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


  # server also runs keycloak for evaluation purposes
  mayniklas.keycloak.enable = true;
  mayniklas.nginx.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/pinpox.keys";
        hash = "sha256-V0ek+L0axLt8v1sdyPXHfZgkbOxqwE3Zw8vOT2aNDcE=";
      })
    ];
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
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };

  system.stateVersion = "22.05";

}
