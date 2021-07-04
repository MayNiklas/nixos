self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };

  # override with newer version from nixpkgs-unstable
  tautulli = self.unstable.tautulli;

  # override with newer version from nixpkgs-unstable (home-manager related)
  chromium = self.unstable.chromium;
  firefox = self.unstable.firefox;
  neovim-unwrapped = self.unstable.neovim-unwrapped;
  obs-studio = self.unstable.obs-studio;
  signal-desktop = self.unstable.signal-desktop;
  youtube-dl = self.unstable.youtube-dl;
}
