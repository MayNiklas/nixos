{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {

  pname = "s3uploader";
  version = "0.1.0";

  src = builtins.filterSource (path: type: false) ./.;

  installPhase = let

    script = ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash

      # go through all result files
      # use --out-link result-*NAME* during build
      for f in result*; do
        for path in $(nix-store -qR $f); do
              signatures=$(nix path-info --sigs --json $path | ${pkgs.jq}/bin/jq "try .[].signatures[]")
          if [[ $signatures == *"cache.lounge.rocks"* ]]; then
            echo "add $path to upload.list"
            echo $path >> upload.list
          fi
        done
      done
      cat upload.list | uniq > upload
      nix copy --to "s3://nix-cache?scheme=https&region=eu-central-1&endpoint=s3.lounge.rocks" $(cat upload)
    '';

  in ''
    mkdir -p $out/bin
    echo '${script}' > $out/bin/s3uploader
    chmod +x $out/bin/s3uploader
  '';
}
