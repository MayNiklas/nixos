# Full example:
# https://tech.ingolf-wagner.de/nixos/krops/

let

  # Basic krops setup
  krops = builtins.fetchGit { url = "https://cgit.krebsco.de/krops/"; };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  source = name:
    lib.evalSource [{

      # Copy over the whole repo. By default nixos-rebuild will use the
      # currents system hostname to lookup the right nixos configuration in
      # `nixosConfigurations` from flake.nix
      machine-config.file = toString ./.;
    }];

  command = targetPath: ''
    nix-shell -p git --run '
      nixos-rebuild switch -v --show-trace --flake ${targetPath}/machine-config || \
        nixos-rebuild switch -v --show-trace --flake ${targetPath}/machine-config
    '
  '';

  # Convenience function to define machines with connection parameters and
  # configuration source
  createHost = name: target:
    pkgs.krops.writeCommand "deploy-${name}" {
      inherit command;
      source = source name;
      target = target;
    };

in rec {

  # Define deployments

  # Run with (e.g.):
  # nix-build ./krop.nix -A kartoffel && ./result

  # Individual machines
  water-on-fire = createHost "water-on-fire" "root@water-on-fire";
  quinjet = createHost "quinjet" "root@quinjet";
  the-hub = createHost "the-hub" "root@the-hub";
  pi4b = createHost "pi4b" "root@pi4b";

  # Groups
  all = pkgs.writeScript "deploy-all"
    (lib.concatStringsSep "\n" [ water-on-fire quinjet the-hub ]);

  servers = pkgs.writeScript "deploy-servers"
    (lib.concatStringsSep "\n" [ quinjet the-hub ]);
}
