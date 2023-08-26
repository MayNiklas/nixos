{ config, pkgs, lib, flake-self, nixpkgs, nixpkgs-unstable, ... }:
with lib;
let cfg = config.mayniklas.nix-common;
in
{

  options.mayniklas.nix-common = {
    enable = mkEnableOption "activate nix-common";
    disable-cache = mkEnableOption "not use binary-cache";
  };

  config = mkIf cfg.enable {

    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
    # this setup with flakes, otherwise commands like `nix-shell
    # -p pkgs.htop` will keep using an old version of nixpkgs.
    # With this entry in $NIX_PATH it is possible (and
    # recommended) to remove the `nixos` channel for both users
    # and root e.g. `nix-channel --remove nixos`. `nix-channel
    # --list` should be empty for all users afterwards
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
    nixpkgs.overlays = [
      flake-self.overlays.default
      (final: prev: {
        unstable = import nixpkgs-unstable {
          system = "${pkgs.system}";
          config.allowUnfree = true;
        };
      })
    ];

    # Allow unfree licenced packages
    nixpkgs.config.allowUnfree = true;

    nix = {

      package = pkgs.nixFlakes;
      extraOptions = ''
        # this enables the technically experimental feature Flakes
        experimental-features = nix-command flakes

        # If set to true, Nix will fall back to building from source if a binary substitute fails.
        fallback = true

        # the timeout (in seconds) for establishing connections in the binary cache substituter. 
        connect-timeout = 10

        # these log lines are only shown on a failed build
        log-lines = 25

        # Free up to 1GiB whenever there is less than 100MiB left.
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      settings = {
        # binary cache -> build by DroneCI
        trusted-public-keys = mkIf (cfg.disable-cache != true) [
          "nix-cache:4FILs79Adxn/798F8qk2PC1U8HaTlaPqptwNJrXNA1g="
          "mayniklas.cachix.org-1:gti3flcBaUNMoDN2nWCOPzCi2P68B5JbA/4jhUqHAFU="
        ];
        substituters = mkIf (cfg.disable-cache != true) [
          "https://cache.lounge.rocks/nix-cache"
          "https://mayniklas.cachix.org"
        ];

        #Users allowed to run nix
        allowed-users = [ "root" ];
        # Save space by hardlinking store files
        auto-optimise-store = true;
      };

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

    };

    # Let 'nixos-version --json' know the Git revision of this flake.
    system.configurationRevision =
      nixpkgs.lib.mkIf (flake-self ? rev) flake-self.rev;
    nix.registry.nixpkgs.flake = nixpkgs;
    nix.registry.mayniklas.flake = flake-self;

  };
}
