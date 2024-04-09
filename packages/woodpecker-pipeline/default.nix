# nix run .\#woodpecker-pipeline
{ pkgs, lib, flake-self, ... }:
with pkgs;
let
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
  forAllSystems = lib.genAttrs supportedSystems;
  pipelineFor =
    forAllSystems (system: writeText "pipeline" (builtins.toJSON {
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
            secrets = [ "attic_key" ];
          };
        in
        pkgs.lib.lists.flatten ([
          (map
            (arch: {
              name = "Hosts with arch: ${arch}";
              data = (builtins.toJSON {
                labels = {
                  backend = "local";
                  platform = woodpecker-platforms."${arch}";
                };
                when = pkgs.lib.lists.flatten ([
                  { event = "manual"; }
                  { event = "push"; branch = "main"; }
                  { event = "pull_request"; repo = "MayNiklas/nixos"; }
                ]);
                steps = pkgs.lib.lists.flatten ([ nixFlakeShow ] ++ [ atticSetupStep ]
                  ++ (map
                  (host:
                    # only build hosts for the arch we are currently building
                    if (flake-self.nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system
                      != arch) then
                      [ ]
                    # Skip hosts with this option set
                    else if
                      flake-self.nixosConfigurations.${host}.config.mayniklas.defaults.CISkip then
                      [ ]
                    else [
                      {
                        name = "Build ${host}";
                        image = "bash";
                        commands = [
                          "nix build --print-out-paths '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                        ];
                      }
                      {
                        "name" = "Show ${host} info";
                        "image" = "bash";
                        "commands" = [
                          "nix path-info --closure-size -h $(readlink -f 'result-${host}')"
                        ];
                      }
                      {
                        name = "Push ${host} to Attic";
                        image = "bash";
                        commands =
                          [ "attic push lounge-rocks:nix-cache 'result-${host}'" ];
                      }
                    ])
                  (builtins.attrNames flake-self.nixosConfigurations)));
              });
            }) [
            "${system}"
          ])
        ]);
    }));
in
pkgs.writeShellScriptBin "woodpecker-pipeline" ''
  # make sure .woodpecker folder exists
  mkdir -p .woodpecker

  # empty content of .woodpecker folder
  rm -rf .woodpecker/*
    
  # copy pipelines to .woodpecker folder
  # cat ${pipelineFor.aarch64-linux} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/arm64-linux.yaml
  cat ${pipelineFor.x86_64-linux} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/x86-linux.yaml
''
