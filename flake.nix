{
  description = "My NixOS infrastructure";

  inputs = {

    # Nix Packages collection
    # https://github.com/NixOS/nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Manage a user environment using Nix 
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pure Nix flake utility functions
    # https://github.com/numtide/flake-utils
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    ### Tools for managing NixOS

    # https://github.com/nix-community/disko
    # Format disks with nix-config
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lollypops deployment tool
    # https://github.com/pinpox/lollypops
    lollypops = {
      url = "github:pinpox/lollypops";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # A collection of NixOS modules covering hardware quirks.
    # https://github.com/NixOS/nixos-hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # Visual Studio Code Server support in NixOS
    # https://github.com/msteen/nixos-vscode-server
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
    };

    # Generate wallpaper images from mathematical functions
    # https://github.com/pinpox/wallpaper-generator
    wallpaper-generator = {
      url = "github:pinpox/wallpaper-generator/";
    };

    # Adblocking lists for Unbound DNS servers running on NixOS
    # https://github.com/MayNiklas/nixos-adblock-unbound
    adblock-unbound = {
      url = "github:MayNiklas/nixos-adblock-unbound";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        adblockStevenBlack.follows = "adblockStevenBlack";
      };
    };

    # Adblocking lists for DNS servers
    # input here, so it will get updated by nix flake update
    adblockStevenBlack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    # A Shelly power metrics exporter written in golang. 
    # https://github.com/MayNiklas/shelly-exporter
    shelly-exporter = {
      url = "github:MayNiklas/shelly-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # A valorant metrics exporter written in golang. 
    # https://github.com/MayNiklas/valorant-exporter
    valorant-exporter = {
      url = "github:MayNiklas/valorant-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # https://github.com/zhaofengli/attic
    # Multi-tenant Nix Binary Cache
    attic = {
      url = "github:zhaofengli/attic";
    };

    # https://github.com/Mic92/nix-fast-build
    # speed-up your evaluation and building process.
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
    };

    # https://github.com/Mic92/nixpkgs-review
    # Review pull-requests on https://github.com/NixOS/nixpkgs 
    nixpkgs-review = {
      url = "github:Mic92/nixpkgs-review";
    };

    # https://github.com/pinpox/ondsel-nix
    # Ondsel (until https://github.com/NixOS/nixpkgs/pull/292995 is merged)
    ondsel = {
      url = "github:pinpox/ondsel-nix";
    };

  };
  outputs = { self, ... }@inputs:
    with inputs;
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlays.default ]; });
    in
    {

      # Use nixpkgs-fmt for `nix fmt'
      formatter = forAllSystems
        (system: nixpkgsFor.${system}.nixpkgs-fmt);

      # Expose overlay to flake outputs, to allow using it from other flakes.
      # Flake inputs are passed to the overlay so that the packages defined in
      # it can use the sources pinned in flake.lock
      overlays.default = final: prev: (import ./overlays inputs) final prev;

      overlays.mayniklas = final: prev: (import ./overlays/mayniklas.nix inputs) final prev;

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs
        (map
          (x: {
            name = x;
            value = { config, pkgs, lib, modulesPath, ... }: {
              imports = [
                (import ./modules/${x} {
                  flake-self = self;
                  inherit pkgs lib config modulesPath inputs nixpkgs;
                })
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./modules)))

      //

      {
        home-manager = { config, pkgs, lib, ... }:
          let
            cfg = config.mayniklas.home-manager;
          in
          {
            imports = [ ./home-manager ];

            home-manager.users."${cfg.username}" = lib.mkIf cfg.enable {
              imports = [
                vscode-server.nixosModules.home
              ];

              # Visual Studio Code Server support
              services.vscode-server.enable = true;

              nixpkgs.overlays = [ self.overlays.mayniklas ];
            };
          };
      };

      # nix run .#homeConfigurations.nik@MacBook-Pro-14-2021.activationPackage
      # home-manager switch --flake .
      homeConfigurations."nik@MacBook-Pro-14-2021" =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            { }
            ./home-manager/profiles/mac.nix
          ];
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = { } // inputs;
        };

      homeManagerModules = builtins.listToAttrs (map
        (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs
        (map
          (x: {
            name = x;
            value = nixpkgs.lib.nixosSystem {

              # Make inputs and the flake itself accessible as module parameters.
              # Technically, adding the inputs is redundant as they can be also
              # accessed with flake-self.inputs.X, but adding them individually
              # allows to only pass what is needed to each module.
              specialArgs = { flake-self = self; } // inputs;

              modules = [
                lollypops.nixosModules.lollypops
                (./machines + "/${x}/configuration.nix")
                { imports = builtins.attrValues self.nixosModules; }
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./machines)));
    }

    //

    # All packages in the ./packages subfolder are also added to the flake.
    # flake-utils is used for this part to make each package available for each
    # system. This works as all packages are compatible with all architectures
    (flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ]))
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default self.overlays.mayniklas ];
            config = {
              allowUnsupportedSystem = true;
              allowUnfree = true;
            };
          };
        in
        rec {

          # Custom packages added via the overlay are selectively exposed here, to
          # allow using them from other flakes that import this one.

          packages = flake-utils.lib.flattenTree {

            build_outputs = pkgs.callPackage ./packages/build_outputs { inherit self; };
            woodpecker-pipeline = pkgs.callPackage ./packages/woodpecker-pipeline { inputs = inputs; flake-self = self; };

            inherit (pkgs.mayniklas)
              ASPM-status
              check-updates
              darknet
              mtu-check
              pycharm-fix
              set-performance
              usb-serial
              vs-fix
              ;

            csgo-server = pkgs.csgo-server;
            drone-gen = pkgs.drone-gen;
            gen-module = pkgs.gen-module;
            preview-update = pkgs.preview-update;
            s3uploader = pkgs.s3uploader;
          };

          # Allow custom packages to be run using `nix run`
          apps = {
            # lollypops deployment tool
            # https://github.com/pinpox/lollypops
            #
            # nix run '.#lollypops' -- --list-all
            # nix run '.#lollypops' -- aida
            # nix run '.#lollypops' -- aida kora
            # nix run '.#lollypops' -- aida deke kora simmons snowflake the-bus -p
            default = self.apps.${pkgs.system}.lollypops;
            lollypops = lollypops.apps.${pkgs.system}.default {
              configFlake = self;
            };

          };
        });
}





