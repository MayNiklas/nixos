let
  krops = (import <nixpkgs> { }).fetchgit {
    url = "https://cgit.krebsco.de/krops/";
    rev = "v1.17.0";
    sha256 = "150jlz0hlb3ngf9a1c9xgcwzz1zz8v2lfgnzw08l3ajlaaai8smd";
  };

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  source = name:
    lib.evalSource [{
      nixos-config.symlink =
        "machine-config/machines/${name}/configuration.nix";

      # Copy repository to /var/src
      machine-config.file = toString ./.;
    }];
in {

  localhost = pkgs.krops.writeDeploy "deploy-localhost" {
    source = source;
    # You can use arbitrary targets here, as long as SSH is correctly
    # configured
    target = "root@localhost";
  };
  
  water-on-fire = pkgs.krops.writeDeploy "deploy-water-on-fire" {
    source = source "water-on-fire";
    target = "root@water-on-fire";
  };

  the-bus = pkgs.krops.writeDeploy "deploy-the-bus" {
    source = source "the-bus";
    target = "root@the-bus";
  };

  # Full example:
  # https://tech.ingolf-wagner.de/nixos/krops/

  # Deploy with (e.g. for server01:
  # nix-build ./krops.nix -A server01 && ./result
}
