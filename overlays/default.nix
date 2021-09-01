self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  owncast = super.pkgs.callPackage ../packages/owncast { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };
  tautulli = super.pkgs.python3Packages.callPackage ../packages/tautulli { };
  verification-listener =
    super.pkgs.python3Packages.callPackage ../packages/verification-listener
    { };

  # override with newer version from nixpkgs-unstable
  # tautulli = self.unstable.tautulli;

  # override with newer version from nixpkgs-unstable (home-manager related)
  chromium = self.unstable.chromium;
  discord = self.unstable.discord;
  firefox = self.unstable.firefox;
  jetbrains.jdk = self.unstable.jetbrains.jdk;
  jetbrains.clion = self.unstable.jetbrains.clion;
  jetbrains.idea-ultimate = self.unstable.jetbrains.idea-ultimate;
  jetbrains.pycharm-professional = self.unstable.jetbrains.pycharm-professional;
  # neovim-unwrapped = self.unstable.neovim-unwrapped;
  obs-studio = self.unstable.obs-studio;
  signal-desktop = self.unstable.signal-desktop;
  spotify = self.unstable.spotify;
  sublime-merge = self.unstable.sublime-merge;
  sublime3 = self.unstable.sublime3;
  teamspeak_client = self.unstable.teamspeak_client;
  tdesktop = self.unstable.tdesktop;
  thunderbird-bin = self.unstable.thunderbird-bin;
  vscode = self.unstable.vscode;
  youtube-dl = self.unstable.youtube-dl;
  zoom-us = self.unstable.zoom-us;
}
