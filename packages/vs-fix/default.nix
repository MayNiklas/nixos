{ pkgs, stdenv, ... }:
let
  vs-fix-skript = pkgs.writeShellScriptBin "vs-fix" ''
    for f in ~/.vscode-server/bin/*; do
      rm $f/node            
      ln -s $(which ${pkgs.nodejs-16_x}/bin/node) $f/node 
    done
    echo "Done patching vs-code server!"
  '';
in stdenv.mkDerivation {

  pname = "vs-fix";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${vs-fix-skript} $out
  '';
}

