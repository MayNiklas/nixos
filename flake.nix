{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, ... }@inputs:
    with inputs;
    let

      # Function to create defult (common) system config options
      defFlakeSystem = systemArch: baseCfg:
        nixpkgs.lib.nixosSystem {

          system = "${systemArch}";
          modules = [

            # Make inputs and overlay accessible as module parameters
            { _module.args.inputs = inputs; }
            { _module.args.self-overlay = self.overlay; }

            ({ ... }: {
              imports = builtins.attrValues self.nixosModules ++ [
                {
                  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                  # this setup with flakes, otherwise commands like `nix-shell
                  # -p pkgs.htop` will keep using an old version of nixpkgs.
                  # With this entry in $NIX_PATH it is possible (and
                  # recommended) to remove the `nixos` channel for both users
                  # and root e.g. `nix-channel --remove nixos`. `nix-channel
                  # --list` should be empty for all users afterwards
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                  nixpkgs.overlays = [ self.overlay ];
                }
                baseCfg
                home-manager.nixosModules.home-manager
                # DONT set useGlobalPackages! It's not necessary in newer
                # home-manager versions and does not work with configs using
                # `nixpkgs.config`
                { home-manager.useUserPackages = true; }
              ];
              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
            })
          ];
        };
      ### BEGIN: tmp fix netcup-qcow2-image
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };
      ### END: tmp fix netcup-qcow2-image
    in {

      # Expose overlay to flake outputs, to allow using it from other flakes.
      overlay = final: prev: (import ./overlays) final prev;

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

      # Each subdirectory in ./machins is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = {

        aida = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/aida/configuration.nix) { inherit self; })
          ];
        };

        arm-server = defFlakeSystem "aarch64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/arm-server/configuration.nix) { inherit self; })
          ];
        };

        deke = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/deke/configuration.nix) { inherit self; })
          ];
        };

        # enoch = defFlakeSystem "x86_64-linux" {
        #   imports = [
        #     # Machine specific config
        #     (import (./machines/enoch/configuration.nix) { inherit self; })
        #   ];
        # };

        flint = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/flint/configuration.nix) { inherit self; })
          ];
        };

        kora = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/kora/configuration.nix) { inherit self; })
          ];
        };

        simmons = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/simmons/configuration.nix) { inherit self; })
          ];
        };

        snowflake = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/snowflake/configuration.nix) { inherit self; })
          ];
        };

        the-bus = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/the-bus/configuration.nix) { inherit self; })
          ];
        };

        the-hub = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/the-hub/configuration.nix) { inherit self; })
          ];
        };

        robin = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/robin/configuration.nix) { inherit self; })
          ];
        };

        water-on-fire = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/water-on-fire/configuration.nix) {
              inherit self;
            })
          ];
        };

        nftables = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./machines/nftables/configuration.nix) { inherit self; })
          ];
        };

        # templates

        hetzner-x86 = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./templates/hetzner-x86/configuration.nix) {
              inherit self;
            })
          ];
        };

        netcup-x86 = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./templates/netcup-x86/configuration.nix) {
              inherit self;
            })
          ];
        };

        vmware-x86 = defFlakeSystem "x86_64-linux" {
          imports = [
            # Machine specific config
            (import (./templates/vmware-x86/configuration.nix) {
              inherit self;
            })
          ];
        };

      };

      # nix build .#netcup-qcow2-image
      netcup-qcow2-image = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
        # See for further options:
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
        config = (self.nixosConfigurations.netcup-x86).config;
        inherit pkgs lib;
        format = "qcow2";
        name = "netcup-image";
        configFile = ./templates/netcup-x86/configuration.nix;
      };

      # hydraJobs = (nixpkgs.lib.mapAttrs' (name: config:
      #   nixpkgs.lib.nameValuePair "nixos-${name}"
      #   config.config.system.build.toplevel) self.nixosConfigurations);

    } //

    # (flake-utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ])
    (flake-utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ])
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
          config = {
            allowUnsupportedSystem = true;
            allowUnfree = true;
          };
        };
      in rec {

        packages = flake-utils.lib.flattenTree {
          anki-bin = pkgs.anki-bin;
          # darknet = pkgs.darknet;
          drone-gen = pkgs.drone-gen;
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
          drone-gen = flake-utils.lib.mkApp { drv = packages.drone-gen; };
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
      });
}
