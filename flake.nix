{
  description = "My NixOS infrastructure";

  inputs = {

    # Nix Packages collection
    # https://github.com/NixOS/nixpkgs
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-22.05";
    };

    # Manage a user environment using Nix 
    # https://github.com/nix-community/home-manager
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage Mac systems using Nix
    # https://github.com/lnl7/nix-darwin
    darwin = {
      type = "github";
      owner = "lnl7";
      repo = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pure Nix flake utility functions
    # https://github.com/numtide/flake-utils
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };

    # lollypops deployment tool
    # https://github.com/pinpox/lollypops
    lollypops = {
      url = "github:pinpox/lollypops";
    };

    # A collection of NixOS modules covering hardware quirks.
    # https://github.com/NixOS/nixos-hardware
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    # nixpkgs update script
    # https://github.com/ryantm/nixpkgs-update
    nixpkgs-update = {
      type = "github";
      owner = "ryantm";
      repo = "nixpkgs-update";
    };

    # Adblocking lists for Unbound DNS servers running on NixOS
    # https://github.com/MayNiklas/nixos-adblock-unbound
    adblock-unbound = {
      type = "github";
      owner = "MayNiklas";
      repo = "nixos-adblock-unbound";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Prometheus exporter providing temperature metrics
    # https://github.com/MayNiklas/dyson-exporter
    dyson-exporter = {
      type = "github";
      owner = "MayNiklas";
      repo = "dyson-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # A Shelly power metrics exporter written in golang. 
    # https://github.com/MayNiklas/shelly-exporter
    shelly-exporter = {
      type = "github";
      owner = "MayNiklas";
      repo = "shelly-exporter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # A valorant metrics exporter written in golang. 
    # https://github.com/MayNiklas/valorant-exporter
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
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
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

      # https://github.com/lnl7/nix-darwin
      # darwin-rebuild switch --flake .
      # nix build .#darwinConfigurations.MacBook-Pro-14-2021.system
      darwinConfigurations.MacBook-Pro-14-2021 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwinConfigurations/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nik = import ./home-manager/profiles/mac.nix;
          }
        ];
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
            lollypops.nixosModules.lollypops
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
    (flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ]))
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
            drone-gen = pkgs.drone-gen;
            s3uploader = pkgs.s3uploader;
            vs-fix = pkgs.vs-fix;
          };

          # Allow custom packages to be run using `nix run`
          apps = {
            drone-gen = flake-utils.lib.mkApp { drv = packages.drone-gen; };
            s3uploader = flake-utils.lib.mkApp { drv = packages.s3uploader; };
            vs-fix = flake-utils.lib.mkApp { drv = packages.vs-fix; };

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
