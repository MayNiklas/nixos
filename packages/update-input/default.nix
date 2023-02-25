{ pkgs, stdenv, ... }:
let
  update-input-skript = pkgs.writeShellScriptBin "update-input" ''
    # update the flake input $1
    ${pkgs.nixFlakes}/bin/nix flake lock --update-input $1

    # Check if flake.lock has unstaged changes
    if ${pkgs.git}/bin/git diff --quiet flake.lock; then
        echo "flake.lock is up to date -> no changes"
    else
        # Commit the changes
        ${pkgs.git}/bin/git add flake.lock
        ${pkgs.git}/bin/git commit -m "nix flake lock --update-input $1"
        echo "flake.lock changes committed"
    fi
  '';
in
stdenv.mkDerivation {

  pname = "update-input";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${update-input-skript} $out
  '';
}

