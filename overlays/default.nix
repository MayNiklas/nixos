inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.

  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  bukkit-spigot = super.pkgs.callPackage ../packages/bukkit-spigot { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  drone-gen = super.pkgs.callPackage ../packages/drone-gen { };
  minecraft-server = super.pkgs.callPackage ../packages/minecraft-server { };
  niki-store = super.pkgs.callPackage ../packages/niki-store { };
  owncast = super.pkgs.callPackage ../packages/owncast { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };
  s3uploader = super.pkgs.callPackage ../packages/s3uploader { };
  tautulli = super.pkgs.python3Packages.callPackage ../packages/tautulli { };
  verification-listener =
    super.pkgs.python3Packages.callPackage ../packages/verification-listener
    { };
  vs-fix = super.pkgs.callPackage ../packages/vs-fix { };
  inherit (super.pkgs.callPackages ../packages/unifi { })
    unifiLTS unifi5 unifi6 unifi7;
  unifi = super.pkgs.unifi7;

  # # override with newer version from nixpkgs-unstable
  # # tautulli = self.unstable.tautulli;

  # # override with newer version from nixpkgs-unstable (home-manager related)
  # chromium = self.unstable.chromium;
  # discord = self.unstable.discord;
  # firefox = self.unstable.firefox;
  # jackett = self.unstable.pkgs.jackett;
  # jetbrains.jdk = self.unstable.jetbrains.jdk;
  # jetbrains.clion = self.unstable.jetbrains.clion;
  # jetbrains.idea-ultimate = self.unstable.jetbrains.idea-ultimate;
  # jetbrains.pycharm-professional = self.unstable.jetbrains.pycharm-professional;
  # # neovim-unwrapped = self.unstable.neovim-unwrapped;
  # obs-studio = self.unstable.obs-studio;
  # signal-desktop = self.unstable.signal-desktop;
  # sonarr = self.unstable.sonarr;
  # spotify = self.unstable.spotify;
  # sublime-merge = self.unstable.sublime-merge;
  # sublime3 = self.unstable.sublime3;
  # teamspeak_client = self.unstable.teamspeak_client;
  # tdesktop = self.unstable.tdesktop;
  # thunderbird-bin = self.unstable.thunderbird-bin;
  # vscode = self.unstable.vscode;
  # youtube-dl = self.unstable.youtube-dl;
  # zoom-us = self.unstable.zoom-us;
}
