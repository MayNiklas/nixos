{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [ mustache-go ];
  shellHook = ''
    echo "[ "aida", "deke", "kora", "simmons", "snowflake", "the-bus", "the-hub", "water-on-fire" ]" | mustache drone-yaml.mustache > .drone.yml
    exit
  '';
}
