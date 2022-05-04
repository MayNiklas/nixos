{ stdenv, lib, bash, jq, ... }:

stdenv.mkDerivation rec {

  pname = "s3uploader";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    install -D skript.sh $out/bin/s3uploader
  '';

  postInstall = ''
    wrapProgram $out/bin/s3uploader \
      --prefix PATH : ${lib.makeBinPath [ bash jq ]}
  '';

}
