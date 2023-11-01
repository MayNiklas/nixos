{ pkgs, stdenv, ... }:
let
  preview-update-skript = pkgs.writeShellScriptBin "preview-update" ''
    export flakeOutput=$1
    export inputs=('nixpkgs')

    export beforeUpdate=$(${pkgs.nix}/bin/nix build $flakeOutput --no-link --print-out-paths)
    echo "before update: $beforeUpdate"

    for input in $inputs; do
      ${pkgs.nix}/bin/nix flake lock --update-input $input
    done

    export afterUpdate=$(${pkgs.nix}/bin/nix build $flakeOutput --no-link --print-out-paths)
    echo "after update: $afterUpdate"

    ${pkgs.nix}/bin/nix store diff-closures $beforeUpdate $afterUpdate

    # revert changes on flake.lock
    ${pkgs.git}/bin/git restore flake.lock
  '';
in
stdenv.mkDerivation {

  pname = "preview-update";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${preview-update-skript} $out
  '';
}

