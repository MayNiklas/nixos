{ pkgs, stdenv, ... }:
let
  vs-fix-skript = pkgs.writeShellScriptBin "vs-fix" ''
    for f in ~/.vscode-server/bin/*; do
      rm $f/node            
      ln -s $(which ${pkgs.nodejs_20}/bin/node) $f/node
    done
    ${pkgs.nix}/bin/nix-store --add-root ~/.vscode-server/.keep-node -r ${pkgs.nodejs_20}
    echo "Done patching vs-code server!"
  '';
in
stdenv.mkDerivation {

  pname = "vs-fix";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${vs-fix-skript} $out
  '';
}

