{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-home.url = "github:mayniklas/nixos-home";
    nixos-home.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-home }:
    let
      # Function to create defult (common) system config options
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Add home-manager option to all configs
            ({ ... }: {
              imports = [
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
        { home-manager.users.nik = nixos-home.nixosModules.server; }
        ./modules/docker.nix
        ./modules/grub.nix
        ./modules/nix-common.nix
        ./modules/networking.nix
        ./modules/locale.nix
        ./modules/hosts.nix
        ./modules/openssh.nix
        ./modules/options.nix
        ./modules/zsh.nix
      ];

      base-modules-desktop = [
        ./users/nik.nix
        { home-manager.users.nik = nixos-home.nixosModules.desktop; }
        ./modules/bluetooth.nix
        ./modules/locale.nix
        ./modules/networking.nix
        ./modules/nix-common.nix
        ./modules/openssh.nix
        ./modules/hosts.nix
        ./modules/options.nix
        ./modules/sound.nix
        ./modules/docker.nix
        ./modules/xserver.nix
        ./modules/yubikey.nix
        ./modules/zsh.nix
      ];
    in {

      nixosConfigurations = {

        water-on-fire = defFlakeSystem {
          imports = base-modules-desktop ++ [
            # Machine specific config
            ./machines/water-on-fire/configuration.nix
            ./machines/water-on-fire/hardware-configuration.nix

            # Users
            ./users/nik.nix
            ./users/root.nix

            # Modules
            ./modules/grub-luks.nix
            ./modules/nvidia.nix
          ];
        };

        quinjet = defFlakeSystem {
          imports = base-modules-server ++ [
            # Machine specific config
            ./machines/quinjet/configuration.nix
            ./machines/quinjet/hardware-configuration.nix
          ];
        };

        the-bus = defFlakeSystem {
          imports = base-modules-server ++ [
            # Machine specific config
            ./machines/the-bus/configuration.nix
            ./machines/the-bus/hardware-configuration.nix
          ];
        };
      };
    };
}
