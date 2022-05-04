self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.

  drone-gen = super.pkgs.writeShellScriptBin "drone-gen" ''
    ${super.pkgs.mustache-go}/bin/mustache drone.json drone-yaml.mustache > .drone.yml
  '';

  s3uploader = super.pkgs.writeShellScriptBin "s3uploader" ''
    # go through all result files
    # use --out-link result-*NAME* during build
    for f in result*; do
      for path in $(nix-store -qR $f); do
            signatures=$(nix path-info --sigs --json $path | ${super.pkgs.jq}/bin/jq 'try .[].signatures[]')
        if [[ $signatures == *"cache.lounge.rocks"* ]]; then
          echo "add $path to upload.list"
          echo $path >> upload.list
        fi
      done
    done
    cat upload.list | uniq > upload
    nix copy --to 's3://nix-cache?scheme=https&region=eu-central-1&endpoint=s3.lounge.rocks' $(cat upload)
  '';

  vs-fix = super.pkgs.writeShellScriptBin "vs-fix" ''
    for f in ~/.vscode-server/bin/*; do
      rm $f/node            
      ln -s $(which ${super.pkgs.nodejs-16_x}/bin/node) $f/node 
    done
  '';

  anki-bin = super.pkgs.callPackage ../packages/anki-bin { };
  bukkit-spigot = super.pkgs.callPackage ../packages/bukkit-spigot { };
  darknet = super.pkgs.callPackage ../packages/darknet { };
  owncast = super.pkgs.callPackage ../packages/owncast { };
  minecraft-server = super.pkgs.callPackage ../packages/minecraft-server { };
  plex = super.pkgs.callPackage ../packages/plex { };
  plexRaw = super.pkgs.callPackage ../packages/plex/raw.nix { };
  tautulli = super.pkgs.python3Packages.callPackage ../packages/tautulli { };

  inherit (super.pkgs.callPackages ../packages/unifi { })
    unifiLTS unifi5 unifi6 unifi7;
  unifi = super.pkgs.unifi7;

  verification-listener =
    super.pkgs.python3Packages.callPackage ../packages/verification-listener
    { };

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
