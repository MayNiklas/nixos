inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.

  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  build-push = super.pkgs.callPackage ../packages/build-push { };
  build-system = super.pkgs.callPackage ../packages/build-system { };
  bukkit-spigot = super.pkgs.callPackage ../packages/bukkit-spigot { };
  csgo-server = super.pkgs.callPackage ../packages/csgo-server { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  drone = super.pkgs.callPackage ../packages/drone { };
  drone-gen = super.pkgs.callPackage ../packages/drone-gen { };
  gen-module = super.pkgs.callPackage ../packages/gen-module { };
  minecraft-server = super.pkgs.callPackage ../packages/minecraft-server { };
  mtu-check = super.pkgs.callPackage ../packages/mtu-check { };
  niki-store = super.pkgs.callPackage ../packages/niki-store { };
  owncast = super.pkgs.callPackage ../packages/owncast { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };
  preview-update = super.pkgs.callPackage ../packages/preview-update { };
  s3uploader = super.pkgs.callPackage ../packages/s3uploader { };
  update-input = super.pkgs.callPackage ../packages/update-input { };
  # tautulli = super.pkgs.python3Packages.callPackage ../packages/tautulli { };
  verification-listener =
    super.pkgs.python3Packages.callPackage ../packages/verification-listener
      { };
  vs-fix = super.pkgs.callPackage ../packages/vs-fix { };
  inherit (super.pkgs.callPackages ../packages/unifi { })
    unifiLTS unifi5 unifi6 unifi7;
  unifi = super.pkgs.unifi7;

}
