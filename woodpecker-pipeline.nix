# nix build .#woodpecker-pipeline && cat result| jq '.configs[].data' -r | jq > .woodpecker.yaml
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
      nixFlakeShow = {
        name = "Nix flake show";
        image = "bash";
        commands = [ "nix flake show" ];
      };
      nixFlakeCheck = {
        name = "Nix flake check";
        image = "bash";
        commands = [ "nix flake check" ];
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
            labels.backend = "local";
            # platform will be deprecated in the future!
            platform = woodpecker-platforms."${arch}";
            steps = pkgs.lib.lists.flatten
              ([ nixFlakeShow nixFlakeCheck atticSetupStep ] ++ (map
                (host:
                  if
                  # Skip hosts with this option set
                    flake-self.nixosConfigurations.${host}.config.mayniklas.defaults.CISkip then
                    [ ]
                  else if
                  # only build hosts for the arch we are currently building
                    (flake-self.nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system
                      != arch) then
                    [ ]
                  else [
                    {
                      name = "Build ${host}";
                      image = "bash";
                      commands = [ "nix build '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'" ];
                    }
                    {
                      name = "Push ${host} to Attic";
                      image = "bash";
                      commands = [ "attic push lounge-rocks:nix-cache 'result-${host}'" ];
                    }
                  ])
                (builtins.attrNames flake-self.nixosConfigurations)));
          });
        }) [ "x86_64-linux" ])
    ]);
})
