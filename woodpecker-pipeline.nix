{ pkgs, flake-self, inputs }:
with pkgs;
writeText "pipeline" (builtins.toJSON {
  configs = let
    atticSetupStep = {
      name = "Setup Attic";
      image = "bash";
      commands = [
        "attic login lounge-rocks https://cache.lounge.rocks $ATTIC_KEY --set-default"
      ];
      secrets = [ "attic_key" ];
    };
    atticPushStep = {
      name = "Push to Attic";
      image = "bash";
      commands = [ "attic push lounge-rocks:nix-cache result" ];
      secrets = [ "attic_key" ];
    };
  in [
    # TODO Show flake info
  ] ++

  # Hosts
  map (host: {
    name = "Host: ${host}";
    data = (builtins.toJSON {
      labels.backend = "local";
      platform = lib.mkIf
        (flake-self.nixosConfigurations.${host}.config.nixpkgs.system
          == "x86_64-linux") "linux/amd64";
      pipeline = [
        atticSetupStep
        {
          name = "Build configuration for ${host}";
          image = "bash";
          commands = [
            "nix build '.#nixosConfigurations.${host}.config.system.build.toplevel'"
          ];
        }
        atticPushStep
      ];
    });
  }) (builtins.attrNames flake-self.nixosConfigurations);
})
