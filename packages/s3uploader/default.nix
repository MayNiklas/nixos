{ pkgs, stdenv, ... }:
let
  s3uploader-skript = pkgs.writeShellScriptBin "s3uploader" ''
    # go through all result files
    # use --out-link result-*NAME* during build
    for f in result*; do
      for path in $(nix-store -qR $f); do
            signatures=$(nix path-info --sigs --json $path | ${pkgs.jq}/bin/jq 'try .[].signatures[]')
        if [[ $signatures == *"cache.lounge.rocks"* ]]; then
          # echo "add $path to upload.list"
          echo $path >> upload.list
        fi
      done
    done
    cat upload.list | uniq > upload
    nix copy --to 's3://nix-cache?scheme=https&region=eu-central-1&endpoint=s3.lounge.rocks&compression=zstd&parallel-compression=true' $(cat upload)
  '';
in
stdenv.mkDerivation {

  pname = "s3uploader";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${s3uploader-skript} $out
  '';
}

