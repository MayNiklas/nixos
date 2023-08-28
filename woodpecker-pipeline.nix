{ pkgs, flake-self, inputs }:
with pkgs;
writeText "pipeline" (builtins.toJSON {
  configs =
    let
      # Map platform names between woodpecker and nix
      # woodpecker-platforms = {
      #   "aarch64-linux" = "linux/arm64";
      #   "x86_64-linux" = "linux/amd64";
      # };
      atticSetupStep = {
        name = "Setup Attic";
        image = "bash";
        commands = [
          "attic login lounge-rocks https://cache.lounge.rocks $ATTIC_KEY --set-default"
        ];
        secrets = [ "attic_key" ];
      };
      mkAtticPushStep = output: {
        name = "Push ${output} to Attic";
        image = "bash";
        commands = [ "attic push lounge-rocks:nix-cache '${output}'" ];
        secrets = [ "attic_key" ];
      };
    in
    [
      # TODO Show flake info
    ] ++

    # Hosts
    pkgs.lib.lists.flatten ([
      (map
        (arch: {
          name = "Hosts with arch: ${arch}";
          data = (builtins.toJSON {
            labels.backend = "local";
            # platform = woodpecker-platforms."${flake-self.nixosConfigurations.${host}.config.nixpkgs.system}";
            steps = pkgs.lib.lists.flatten ([ atticSetupStep ] ++ (map
              (host:
                if
                # Skip hosts with this option set
                  flake-self.nixosConfigurations.${host}.config.mayniklas.defaults.CISkip then
                  [ ]
                else [
                  {
                    name = "Build configuration for ${host}";
                    image = "bash";
                    commands = [
                      "nix build '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                    ];
                  }
                  (mkAtticPushStep "result-${host}")
                ])
              (builtins.attrNames flake-self.nixosConfigurations)));
          });
        }) [ "x86_64-linux" ])
    ]);
})
