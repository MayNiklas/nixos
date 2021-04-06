{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-home.url = "github:mayniklas/nixos-home";
    nixos-home.inputs.nixpkgs.follows = "nixpkgs";

    pinpox.url =
      "github:pinpox/nixos?rev=2212778ccd38a027eaa914c379eed841ae7a7a95";
    pinpox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... }@inputs:
    with inputs;
    let
      # Function to create defult (common) system config options
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Add home-manager option to all configs
            ({ ... }: {
              imports = builtins.attrValues self.nixosModules ++ [
                pinpox.nixosModules.hello
                {
                  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                  # this setup with flakes, otherwise commands like `nix-shell
                  # -p pkgs.htop` will keep using an old version of nixpkgs.
                  # With this entry in $NIX_PATH it is possible (and
                  # recommended) to remove the `nixos` channel for both users
                  # and root e.g. `nix-channel --remove nixos`. `nix-channel
                  # --list` should be empty for all users afterwards
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
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

      base-modules-server = [
        ./users/nik.nix
        ./users/root.nix
        { home-manager.users.nik = nixos-home.nixosModules.server; }
      ];

      base-modules-desktop =
        [{ home-manager.users.nik = nixos-home.nixosModules.desktop; }];

    in {

      nixosModules = {
        # modules
        bluetooth = import ./modules/bluetooth;
        desktop = import ./modules/desktop;
        docker = import ./modules/docker;
        grub = import ./modules/grub;
        grub-luks = import ./modules/grub-luks;
        hellonik = import ./modules/hellonik;
        hosts = import ./modules/hosts;
        kde = import ./modules/kde;
        librespeedtest = import ./modules/librespeedtest;
        locale = import ./modules/locale;
        networking = import ./modules/networking;
        nix-common = import ./modules/nix-common;
        nvidia = import ./modules/nvidia;
        openssh = import ./modules/openssh;
        options = import ./modules/options;
        pihole = import ./modules/pihole;
        server = import ./modules/server;
        screen-config = import ./modules/screen-config;
        plex = import ./modules/plex;
        sound = import ./modules/sound;
        xserver = import ./modules/xserver;
        yubikey = import ./modules/yubikey;
        zsh = import ./modules/zsh;

        # containers
        in-stock-bot = import ./modules/containers/in-stock;
        plex-version = import ./modules/containers/plex-version;
        scene-extractor = import ./modules/containers/scene-extractor-AOS;
        youtube-dl = import ./modules/containers/web-youtube-dl;
      };

      nixosConfigurations = {

        water-on-fire = defFlakeSystem {
          imports = base-modules-desktop ++ [
            # Machine specific config
            ./machines/water-on-fire/configuration.nix
          ];
        };

        quinjet = defFlakeSystem {
          imports = base-modules-server ++ [
            # Machine specific config
            ./machines/quinjet/configuration.nix
          ];
        };

      };
    };
}
