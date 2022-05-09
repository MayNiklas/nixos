{ config, pkgs, lib, flake-self, nixpkgs, ... }:
with lib;
let cfg = config.mayniklas.nix-common;
in {

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
    nixpkgs.overlays = [ flake-self.overlays.default ];

    # Allow unfree licenced packages
    nixpkgs.config.allowUnfree = true;

    nix = {

      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
        # Free up to 1GiB whenever there is less than 100MiB left.
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      # binary cache -> build by DroneCI
      binaryCachePublicKeys = mkIf (cfg.disable-cache != true)
        [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
      binaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.nixos.org"
        "https://cache.lounge.rocks?priority=100"
        "https://s3.lounge.rocks/nix-cache?priority=50"
      ];
      trustedBinaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.nixos.org"
        "https://cache.lounge.rocks"
        "https://s3.lounge.rocks/nix-cache/"
      ];

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Users allowed to run nix
      allowedUsers = [ "root" ];

    };

    # Let 'nixos-version --json' know the Git revision of this flake.
    system.configurationRevision =
      nixpkgs.lib.mkIf (flake-self ? rev) flake-self.rev;
    nix.registry.nixpkgs.flake = nixpkgs;
    nix.registry.mayniklas.flake = flake-self;

    environment.etc."nix/flake_inputs.prom" = {
      mode = "0555";
      text = ''
        # HELP flake_registry_last_modified Last modification date of flake input in unixtime
        # TYPE flake_input_last_modified gauge
        ${concatStringsSep "\n" (map (i:
          ''
            flake_input_last_modified{input="${i}",${
              concatStringsSep "," (mapAttrsToList (n: v: ''${n}="${v}"'')
                (filterAttrs (n: v: (builtins.typeOf v) == "string")
                  flake-self.inputs."${i}"))
            }} ${toString flake-self.inputs."${i}".lastModified}'')
          (attrNames flake-self.inputs))}
      '';
    };

  };
}
