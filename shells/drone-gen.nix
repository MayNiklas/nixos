{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [ mustache-go ];
  shellHook = ''
    mustache drone.json drone-yaml.mustache > .drone.yml
    exit
  '';
}
