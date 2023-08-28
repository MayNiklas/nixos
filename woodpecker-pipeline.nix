{ pkgs, flake-self, inputs }:
with pkgs;
writeText "pipeline" (builtins.toJSON {
  configs =
    let
      # Map platform names between woodpecker and nix
      woodpecker-platforms = {
        "aarch64-linux" = "linux/arm64";
        "x86_64-linux" = "linux/amd64";
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
    [
      {
        name = "Nix flake check";
        data = (builtins.toJSON {
          labels.backend = "local";
          platform = "linux/amd64";
          steps = [
            {
              name = "nix flake show";
              image = "bash";
              commands = [
                "nix flake show"
              ];
            }
            {
              name = "nix flake info";
              image = "bash";
              commands = [
                "nix flake info"
              ];
            }
            {
              name = "nix flake check";
              image = "bash";
              commands = [
                "nix flake check"
              ];
            }
          ];
        });
      }
    ] ++
    # Hosts
    pkgs.lib.lists.flatten ([
      (map
        (arch: {
          name = "Hosts with arch: ${arch}";
          data = (builtins.toJSON {
            labels.backend = "local";
            # platform will be deprecated in the future!
            platform = woodpecker-platforms."${arch}";
            steps = pkgs.lib.lists.flatten ([ atticSetupStep ] ++ (map
              (host:
                if
                # Skip hosts with this option set
                  flake-self.nixosConfigurations.${host}.config.mayniklas.defaults.CISkip then
                  [ ]
                else if
                # only build hosts for the arch we are currently building
                  (flake-self.nixosConfigurations.${host}.config.nixpkgs.system != arch) then
                  [ ]
                else [
                  {
                    name = "Build configuration for ${host}";
                    image = "bash";
                    commands = [
                      "nix build '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                      "attic push lounge-rocks:nix-cache 'result-${host}'"
                    ];
                  }
                ])
              (builtins.attrNames flake-self.nixosConfigurations)));
          });
        }) [ "x86_64-linux" "aarch64-linux" ])
    ]);
})
