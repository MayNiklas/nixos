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
  build-system = super.pkgs.callPackage ../packages/build-system { };
  bukkit-spigot = super.pkgs.callPackage ../packages/bukkit-spigot { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  drone = super.pkgs.callPackage ../packages/drone { };
  drone-gen = super.pkgs.callPackage ../packages/drone-gen { };
  minecraft-server = super.pkgs.callPackage ../packages/minecraft-server { };
  mtu-check = super.pkgs.callPackage ../packages/mtu-check { };
  niki-store = super.pkgs.callPackage ../packages/niki-store { };
  owncast = super.pkgs.callPackage ../packages/owncast { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };
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

  # override with newer version from nixpkgs-unstable
  discord = self.unstable.discord;
  firefox = self.unstable.firefox;
  foot = self.unstable.foot;
  htop = self.unstable.htop;
  hugo = self.unstable.hugo;
  nvtop = self.unstable.nvtop;
  spotify = self.unstable.spotify;
  sway = self.unstable.sway;
  swayidle = self.unstable.swayidle;
  swaylock = self.unstable.swaylock;
  waybar = self.unstable.waybar;
  wlay = self.unstable.wlay;
  wofi = self.unstable.wofi;
  zoom-us = self.unstable.zoom-us;
  zsh = self.unstable.zsh;
}
