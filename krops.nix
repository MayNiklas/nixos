let
  krops = (import <nixpkgs> { }).fetchgit {
    url = "https://cgit.krebsco.de/krops/";
    rev = "v1.17.0";
    sha256 = "150jlz0hlb3ngf9a1c9xgcwzz1zz8v2lfgnzw08l3ajlaaai8smd";
  };

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  source = lib.evalSource [{

    # You might want to set your nixpkgs branch here
    nixpkgs.git = {
      ref = "origin/nixos-20.09";
      url = "https://github.com/NixOS/nixpkgs";
    };

    # Use the existing confiruatio.nix file as base
    nixos-config.file = toString ./configuration.nix;
  }];
in {

  # Create a deploment for localhost. You can define multiple hosts here, with
  # arbitrary names
  localhost = pkgs.krops.writeDeploy "deploy-localhost" {
    source = source;
    # You can use arbitrary targets here, as long as SSH is correctly
    # configured
    target = "root@localhost";
  };

  # Here is how you would add other machines:
  #
  # server02 = pkgs.krops.writeDeploy "deploy-server02" {
  #    source = source;
  #    target = "root@server01";
  #  };

  # server02 = pkgs.krops.writeDeploy "deploy-server02" {
  #    source = source;
  #    target = "root@server02.mydomain.org";
  #  };

  # Full example:
  # https://tech.ingolf-wagner.de/nixos/krops/

  # Deploy with (e.g. for server01:
  # nix-build ./krops.nix -A server01 && ./result
}
