{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {

  pname = "hello-world";
  version = "0.1.0";

  src = builtins.filterSource (path: type: false) ./.;

  installPhase = let

    script = ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash

      echo hello-world!
    '';

  in ''
    mkdir -p $out/bin
    echo '${script}' > $out/bin/hello-world
    chmod +x $out/bin/hello-world
  '';
}
