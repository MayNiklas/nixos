{ pkgs, stdenv, ... }:
stdenv.mkDerivation {

  pname = "drone-gen";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin $out/lib/
    ${pkgs.coreutils}/bin/cp $src/drone-yaml.mustache $out/lib/drone-yaml.mustache

    cat > $out/bin/drone-gen << EOF
    #!/bin/sh
    ${pkgs.mustache-go}/bin/mustache drone.json ${placeholder "out"}/lib/drone-yaml.mustache > .drone.yml
    EOF

    chmod +x $out/bin/drone-gen
  '';
}
