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
  aida = createHost "aida" "root@aida";
  deke = createHost "deke" "root@deke";
  enoch = createHost "enoch" "root@enoch";
  kora = createHost "kora" "root@kora";
  snowflake = createHost "snowflake" "root@snowflake";
  the-hub = createHost "the-hub" "root@the-hub";
  the-bus = createHost "the-bus" "root@the-bus";

  # Groups
  all = pkgs.writeScript "deploy-all" (lib.concatStringsSep "\n" [
    aida
    kora
    deke
    enoch
    snowflake
    water-on-fire
    the-hub
    the-bus
  ]);

  servers = pkgs.writeScript "deploy-servers"
    (lib.concatStringsSep "\n" [ aida kora deke snowflake the-hub the-bus ]);
}
