{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {

  pname = "vs-fix";
  version = "0.1.0";

  src = builtins.filterSource (path: type: false) ./.;

  installPhase = let

    script = ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash

      for f in ~/.vscode-server/bin/*; do
        rm $f/node            
        ln -s $(which ${pkgs.nodejs-16_x}/bin/node) $f/node 
      done
      
      echo "Done patching vs-code server!"
    '';

  in ''
    mkdir -p $out/bin
    echo '${script}' > $out/bin/vs-fix
    chmod +x $out/bin/vs-fix
  '';
}
