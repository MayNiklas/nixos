{
  description = "My NixOS infrastructure";

  inputs = {

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-22.05";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };

    lollypops = {
      url = "github:pinpox/lollypops";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    nixpkgs-update = {
      type = "github";
      owner = "ryantm";
      repo = "nixpkgs-update";
    };

    adblock-unbound = {
      type = "github";
      owner = "MayNiklas";
      repo = "nixos-adblock-unbound";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    dyson-exporter = {
      type = "github";
      owner = "MayNiklas";
      repo = "dyson-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    shelly-exporter = {
      type = "github";
      owner = "MayNiklas";
      repo = "shelly-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    valorant-exporter = {
      type = "github";
      owner = "MayNiklas";
      repo = "valorant-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

  };
  outputs = { self, ... }@inputs:
    with inputs;
    {

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
            value = import (./modules + "/${x}");
          })
          (builtins.attrNames (builtins.readDir ./modules)))

      //

      {
        home-manager = { config, pkgs, lib, ... }: {
          imports = [ ./home-manager ];
        };
      };

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

              system = "x86_64-linux";

              modules = [
                lollypops.nixosModules.lollypops
                (./machines + "/${x}/configuration.nix")
                { imports = builtins.attrValues self.nixosModules; }
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./machines)))

      // {

        hetzner-x86 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { flake-self = self; } // inputs;
          modules = [
            ./images/hetzner-x86/configuration.nix
            { imports = builtins.attrValues self.nixosModules; }
          ];
        };

      };

      # nix build '.#netcup-x86-image'
      netcup-x86-image =
        let system = "x86_64-linux";
        in
        import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
          pkgs = nixpkgs.legacyPackages."${system}";
          lib = nixpkgs.lib;
          config = (nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./images/netcup-x86/configuration.nix ];
          }).config;
          format = "qcow2";
          name = "base-image";
        };

      # nix build .#vmware-x86-image.config.system.build.vmwareImage
      vmware-x86-image =
        let system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { flake-self = self; } // inputs;
          lib = nixpkgs.lib;
          modules = [
            ./images/vmware-x86/configuration.nix
            { imports = builtins.attrValues self.nixosModules; }
          ];
        };

    } //

    # All packages in the ./packages subfolder are also added to the flake.
    # flake-utils is used for this part to make each package available for each
    # system. This works as all packages are compatible with all architectures
    (flake-utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ])
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config = {
              allowUnsupportedSystem = true;
              allowUnfree = true;
            };
          };
        in
        rec {

          # Use nixpkgs-fmt for `nix fmt'
          formatter = pkgs.nixpkgs-fmt;

          # Custom packages added via the overlay are selectively exposed here, to
          # allow using them from other flakes that import this one.

          packages = flake-utils.lib.flattenTree {
            anki-bin = pkgs.anki-bin;
            # darknet = pkgs.darknet;
            drone = pkgs.drone;
            drone-gen = pkgs.drone-gen;
            niki-store = pkgs.niki-store;
            owncast = pkgs.owncast;
            plex = pkgs.plex;
            plexRaw = pkgs.plexRaw;
            s3uploader = pkgs.s3uploader;
            tautulli = pkgs.tautulli;
            unifi = pkgs.unifi;
            unifi5 = pkgs.unifi5;
            unifi6 = pkgs.unifi6;
            unifi7 = pkgs.unifi7;
            unifiLTS = pkgs.unifiLTS;
            verification-listener = pkgs.verification-listener;
            vs-fix = pkgs.vs-fix;
          };
          apps = {
            # Allow custom packages to be run using `nix run`
            anki-bin = flake-utils.lib.mkApp { drv = packages.anki-bin; };
            # darknet = flake-utils.lib.mkApp { drv = packages.darknet; };
            drone = flake-utils.lib.mkApp { drv = packages.drone; };
            drone-gen = flake-utils.lib.mkApp { drv = packages.drone-gen; };
            niki-store = flake-utils.lib.mkApp { drv = packages.niki-store; };
            owncast = flake-utils.lib.mkApp { drv = packages.owncast; };
            plex = flake-utils.lib.mkApp { drv = packages.plex; };
            plexRaw = flake-utils.lib.mkApp { drv = packages.plexRaw; };
            s3uploader = flake-utils.lib.mkApp { drv = packages.s3uploader; };
            tautulli = flake-utils.lib.mkApp { drv = packages.tautulli; };
            unifi = flake-utils.lib.mkApp { drv = packages.unifi; };
            unifi5 = flake-utils.lib.mkApp { drv = packages.unifi5; };
            unifi6 = flake-utils.lib.mkApp { drv = packages.unifi6; };
            unifi7 = flake-utils.lib.mkApp { drv = packages.unifi7; };
            unifiLTS = flake-utils.lib.mkApp { drv = packages.unifiLTS; };
            verification-listener =
              flake-utils.lib.mkApp { drv = packages.verification-listener; };
            vs-fix = flake-utils.lib.mkApp { drv = packages.vs-fix; };
          };
          # lollypops deployment tool
          # https://github.com/pinpox/lollypops
          apps.default = lollypops.apps.${pkgs.system}.default { configFlake = self; };
        });
}
