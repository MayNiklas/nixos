# nix run .\#woodpecker-pipeline
{
  pkgs,
  lib,
  flake-self,
  ...
}:
with pkgs;
let
  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
  ];

  woodpecker-filenames = {
    "aarch64-linux" = "arm64-linux.yaml";
    "x86_64-linux" = "x86-linux.yaml";
  };

  # Only generate pipelines for architectures used by at least one nixosConfiguration
  activeSystems = lib.filter
    (system: lib.any
      (host: flake-self.nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system == system)
      (builtins.attrNames flake-self.nixosConfigurations))
    supportedSystems;

  pipelineFor = lib.genAttrs activeSystems (
    system:
    writeText "pipeline" (
      builtins.toJSON {
        configs =
          let
            # Map platform names between woodpecker and nix
            woodpecker-platforms = {
              "aarch64-linux" = "linux/arm64";
              "x86_64-linux" = "linux/amd64";
            };
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
                ''nix-fast-build --no-nom --skip-cached --attic-cache lounge-rocks:nix-cache --flake ".#checks.$(nix eval --raw --impure --file builtins.currentSystem)"''
              ];
            };
            verifyBuildsStep = {
              name = "Verify all builds succeeded";
              image = "bash";
              commands = [
                ''nix-fast-build --no-nom --skip-cached --flake ".#checks.$(nix eval --raw --impure --file builtins.currentSystem)"''
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
                      [ nixFlakeShow ]
                      ++ [ atticSetupStep ]
                      ++ [ nixFastBuildStep ]
                      ++ (map (
                        host:
                        # only build hosts for the arch we are currently building
                        if (flake-self.nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system != arch) then
                          [ ]
                        # Skip hosts with this option set
                        else if flake-self.nixosConfigurations.${host}.config.mayniklas.defaults.CISkip then
                          [ ]
                        else
                          [
                            {
                              name = "Build ${host}";
                              image = "bash";
                              failure = "ignore";
                              commands = [
                                "nix build --print-out-paths '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                              ];
                            }
                            {
                              "name" = "Show ${host} info";
                              "image" = "bash";
                              "failure" = "ignore";
                              "commands" = [
                                "nix path-info --closure-size -h $(readlink -f 'result-${host}')"
                              ];
                            }
                            # {
                            #   name = "Push ${host} to Attic";
                            #   image = "bash";
                            #   failure = "ignore";
                            #   commands = [ "attic push lounge-rocks:nix-cache 'result-${host}'" ];
                            # }
                          ]
                      ) (builtins.attrNames flake-self.nixosConfigurations))
                      ++ [ verifyBuildsStep ]
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
  ${lib.concatStrings (map (system: ''
    cat ${pipelineFor.${system}} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/${woodpecker-filenames.${system}}
  '') activeSystems)}
''
