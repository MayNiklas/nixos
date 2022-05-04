{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {

  pname = "drone-gen";
  version = "0.1.0";

  src = builtins.filterSource (path: type: false) ./.;

  installPhase = let

    script = ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash

      ${pkgs.mustache-go}/bin/mustache drone.json drone-yaml.mustache > .drone.yml
    '';

  in ''
    mkdir -p $out/bin
    echo '${script}' > $out/bin/drone-gen
    chmod +x $out/bin/drone-gen
  '';
}
