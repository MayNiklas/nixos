# nix run .\#woodpecker-pipeline
{
  pkgs,
  lib,
  hostMeta,
  ...
}:
with pkgs;
let
  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
  ];

  woodpecker-platforms = {
    "aarch64-linux" = "linux/arm64";
    "x86_64-linux" = "linux/amd64";
  };

  woodpecker-filenames = {
    "aarch64-linux" = "arm64-linux.yaml";
    "x86_64-linux" = "x86-linux.yaml";
  };

  hosts = builtins.attrNames hostMeta;
  checkedHosts = lib.filter (host: hostMeta.${host}.inChecks) hosts;

  # Only generate pipelines for architectures used by at least one nixosConfiguration
  activeSystems = lib.filter (
    system: lib.any (host: hostMeta.${host}.system == system) checkedHosts
  ) supportedSystems;

  pipelineFor = lib.genAttrs activeSystems (
    system:
    writeText "pipeline" (
      builtins.toJSON {
        configs =
          let
            nixFlakeShow = {
              name = "Nix flake show";
              image = "bash";
              commands = [ "nix flake show" ];
            };
            atticSetupStep = {
              name = "Setup Attic";
              image = "bash";
              commands = [
                "attic login lounge-rocks https://cache.lounge.rocks $ATTIC_KEY --set-default"
              ];
              environment = {
                ATTIC_KEY.from_secret = "attic_key";
              };
            };
            nixFastBuildStep = {
              name = "Build all outputs for this architecture";
              image = "bash";
              failure = "ignore";
              commands = [
                ''nix-fast-build --no-nom --skip-cached --attic-cache lounge-rocks:nix-cache --flake ".#checks.${system}"''
              ];
            };
            verifyBuildsStep =
              arch:
              let
                activeHosts = lib.filter (host: hostMeta.${host}.system == arch) checkedHosts;
              in
              {
                name = "Verify all builds succeeded";
                image = "bash";
                "when" = {
                  "status" = "failure";
                };
                commands = map (host: "test -e 'result-${host}'") activeHosts ++ [
                  "echo 'All builds succeeded.'"
                ];
              };
          in
          pkgs.lib.lists.flatten ([
            (map
              (arch: {
                name = "Hosts with arch: ${arch}";
                data = (
                  builtins.toJSON {
                    labels = {
                      backend = "local";
                      platform = woodpecker-platforms."${arch}";
                    };
                    when = pkgs.lib.lists.flatten ([
                      { event = "manual"; }
                      {
                        event = "push";
                        branch = "main";
                      }
                      {
                        event = "push";
                        branch = "update_flake_lock_action";
                      }
                    ]);
                    steps = pkgs.lib.lists.flatten (
                      # [ nixFlakeShow ]
                      [ atticSetupStep ]
                      ++ [ nixFastBuildStep ]
                      ++ (map (
                        host:
                        # only build hosts for the arch we are currently building
                        if (hostMeta.${host}.system != arch) then
                          [ ]
                        # Only include hosts that are part of flake checks
                        else if !hostMeta.${host}.inChecks then
                          [ ]
                        else
                          [
                            {
                              name = "Rebuild ${host} (diagnostic)";
                              image = "bash";
                              failure = "ignore";
                              "when" = {
                                "status" = "failure";
                              };
                              commands = [
                                "nix build --print-out-paths '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                              ];
                            }
                            {
                              name = "Show ${host} info";
                              image = "bash";
                              failure = "ignore";
                              commands = [
                                "nix path-info --closure-size -h $(readlink -f 'result-${host}')"
                              ];
                            }
                          ]
                      ) hosts)
                      ++ [ (verifyBuildsStep arch) ]
                    );
                  }
                );
              })
              [
                "${system}"
              ]
            )
          ]);
      }
    )
  );
in
pkgs.writeShellScriptBin "woodpecker-pipeline" ''
  # make sure .woodpecker folder exists
  mkdir -p .woodpecker

  # empty content of .woodpecker folder
  rm -rf .woodpecker/*

  # copy pipelines to .woodpecker folder (only for architectures present in the flake)
  ${lib.concatStrings (
    map (system: ''
      cat ${pipelineFor.${system}} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/${woodpecker-filenames.${system}}
    '') activeSystems
  )}
''
