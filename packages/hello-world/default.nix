{ stdenv, ... }:

stdenv.mkDerivation rec {

  pname = "hello-world";
  version = "0.1.0";

  src = builtins.filterSource (path: type: false) ./.;

  installPhase = let

    script = ''
      #!/bin/bash
      echo Hello world!
    '';

  in ''
    mkdir -p $out/bin
    echo '${script}' > $out/bin/hello-world
    chmod +x $out/bin/hello-world
  '';
}
