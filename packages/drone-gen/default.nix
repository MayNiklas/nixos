{ pkgs, stdenv, ... }:
let
  drone-gen-skript = pkgs.writeShellScriptBin "drone-gen" ''
    ${pkgs.mustache-go}/bin/mustache drone.json drone-yaml.mustache > .drone.yml
  '';
in stdenv.mkDerivation {

  pname = "drone-gen";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${drone-gen-skript} $out
  '';
}
