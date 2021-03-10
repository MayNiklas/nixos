# Full example:
# https://tech.ingolf-wagner.de/nixos/krops/

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

  water-on-fire = pkgs.krops.writeDeploy "deploy-water-on-fire" {
    source = source "water-on-fire";
    target = "root@water-on-fire";
  };

  quinjet = pkgs.krops.writeDeploy "deploy-quinjet" {
    source = source "quinjet";
    target = "root@quinjet";
  };

  the-bus = pkgs.krops.writeDeploy "deploy-the-bus" {
    source = source "the-bus";
    target = "root@the-bus";
  };

in {

  # nix-build ./krops.nix -A water-on-fire && ./result -j16
  water-on-fire = water-on-fire;

  # nix-build ./krops.nix -A quinjet && ./result -j8
  quinjet = quinjet;

  # nix-build ./krops.nix -A the-bus && ./result -j4
  the-bus = the-bus;

  # nix-build ./krops.nix -A all && ./result -j16
  all = pkgs.writeScript "deploy-all-servers"
    (lib.concatStringsSep "\n" [ water-on-fire quinjet ]);

}
