#! /bin/bash

# go through all result files
# use --out-link result-*NAME* during build

for f in result*; do
  for path in $(nix-store -qR $f); do
        signatures=$(nix path-info --sigs --json $path | jq 'try .[].signatures[]')
    if [[ $signatures == *"cache.lounge.rocks"* ]]; then
      echo "add $path to upload.list"
      echo $path >> upload.list
    fi
  done
done
cat upload.list | uniq > upload
nix copy --to 's3://nix-cache?scheme=https&region=eu-central-1&endpoint=s3.lounge.rocks' $(cat upload)
