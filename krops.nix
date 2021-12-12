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
      nix build -v '${targetPath}/machine-config#nixosConfigurations.$(hostname).config.system.build.toplevel' && \
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
  # nix-build ./krops.nix -A all && ./result
  # nix-build ./krops.nix -A servers && ./result
  #
  # nix-build ./krops.nix -A aida && ./result
  # nix-build ./krops.nix -A deke && ./result
  # nix-build ./krops.nix -A enoch && ./result
  # nix-build ./krops.nix -A kora && ./result
  # nix-build ./krops.nix -A simmons && ./result
  # nix-build ./krops.nix -A snowflake && ./result
  # nix-build ./krops.nix -A the-hub && ./result
  # nix-build ./krops.nix -A the-bus && ./result
  # nix-build ./krops.nix -A water-on-fire && ./result

  # Individual machines
  water-on-fire = createHost "water-on-fire" "root@water-on-fire";
  aida = createHost "aida" "root@aida";
  deke = createHost "deke" "root@deke";
  enoch = createHost "enoch" "root@enoch";
  flint = createHost "flint" "root@flint";
  kora = createHost "kora" "root@kora";
  simmons = createHost "simmons" "root@simmons";
  snowflake = createHost "snowflake" "root@snowflake";
  the-hub = createHost "the-hub" "root@the-hub";
  the-bus = createHost "the-bus" "root@the-bus";
  arm-server = createHost "arm-server" "root@158.101.217.241";

  # Groups
  all = pkgs.writeScript "deploy-all" (lib.concatStringsSep "\n" [
    aida
    flint
    kora
    deke
    enoch
    simmons
    snowflake
    water-on-fire
    the-hub
    the-bus
  ]);

  servers = pkgs.writeScript "deploy-servers"
    (lib.concatStringsSep "\n" [ aida flint kora deke simmons snowflake the-hub the-bus ]);
}
