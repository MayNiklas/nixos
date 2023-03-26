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
      enable = true;
      package = pkgs.authelia;
      settings = {
        theme = "dark";
        server = {
          host = "0.0.0.0";
          port = 9091;
        };

        authentication_backend = {
          file.path = "/var/lib/authelia-main/user.yml";
        };

        storage.local.path = "/var/lib/authelia-main/db.sqlite";

        session = {
          secret = "this-is-just-a-test-secret";
          domain = "authelia.lounge.rocks";
          expiration = 3600; # 1 hour
          inactivity = 300; # 5 minutes
        };
        # redis:
        #   host: redis
        #   port: 6379

        notifier.filesystem.filename = "/var/lib/authelia-main/emails.txt";

        access_control = {
          default_policy = "bypass";
          rules = [
            {
              domain = "public.example.com";
              policy = "bypass";
            }
            {
              domain = "traefik.example.com";
              policy = "one_factor";
            }
          ];
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



    services.nginx.virtualHosts = {
      "authelia.lounge.rocks" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:9091";
            # extraConfig = ''
            #   proxy_set_header X-Forwarded-Host $http_host;
            #   proxy_set_header X-Real-IP $remote_addr;
            #   proxy_set_header X-Forwarded-Proto $scheme;
            # '';
          };
        };
      };
    };


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
