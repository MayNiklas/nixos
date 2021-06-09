self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRAW = super.pkgs.callPackage ../packages/plex/raw.nix { };
}
