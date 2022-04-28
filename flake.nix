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
          drone-gen = pkgs.writeShellScriptBin "drone-gen" ''
            ${pkgs.mustache-go}/bin/mustache drone.json drone-yaml.mustache > .drone.yml
          '';
          owncast = pkgs.owncast;
          plex = pkgs.plex;
          plexRaw = pkgs.plexRaw;
          tautulli = pkgs.tautulli;
          verification-listener = pkgs.verification-listener;
          s3uploader = pkgs.writeShellScriptBin "s3uploader" ''
            # go through all result files
            # use --out-link result-*NAME* during build
            for f in result*; do
              for path in $(nix-store -qR $f); do
                    signatures=$(nix path-info --sigs --json $path | ${pkgs.jq}/bin/jq 'try .[].signatures[]')
                if [[ $signatures == *"cache.lounge.rocks"* ]]; then
                  echo "add $path to upload.list"
                  echo $path >> upload.list
                fi
              done
            done
            cat upload.list | uniq > upload
            nix copy --to 's3://nix-cache?scheme=https&region=eu-central-1&endpoint=s3.lounge.rocks' $(cat upload)
          '';
          vs-fix = pkgs.writeShellScriptBin "vs-fix" ''
            for f in ~/.vscode-server/bin/*; do
              rm $f/node            
              ln -s $(which ${pkgs.nodejs-16_x}/bin/node) $f/node 
            done
          '';
        };
        apps = {
          # Allow custom packages to be run using `nix run`
          anki-bin = flake-utils.lib.mkApp { drv = packages.anki-bin; };
          # darknet = flake-utils.lib.mkApp { drv = packages.darknet; };
          drone-gen = flake-utils.lib.mkApp { drv = packages.drone-gen; };
          owncast = flake-utils.lib.mkApp { drv = packages.owncast; };
          plex = flake-utils.lib.mkApp { drv = packages.plex; };
          plexRaw = flake-utils.lib.mkApp { drv = packages.plexRaw; };
          tautulli = flake-utils.lib.mkApp { drv = packages.tautulli; };
          verification-listener =
            flake-utils.lib.mkApp { drv = packages.verification-listener; };
          s3uploader = flake-utils.lib.mkApp { drv = packages.s3uploader; };
          vs-fix = flake-utils.lib.mkApp { drv = packages.vs-fix; };
        };
      });
}
