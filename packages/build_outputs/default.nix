# This package references all the outputs we want to keep around in the nix-store.
# It builds all our NixOS systems and packages, since it depends on them.
# -> might be useful for different use cases:
#   - keep all the build outputs around for a while
#   - build all systems and packages at once
#   - compare systems with nix-tree
#   - make sure everything is present in the local nix-store for deploying to a remote machine
#
# nix run .#build_outputs
# nix-tree $(nix build --print-out-paths .#build_outputs)
{ pkgs, self, ... }:
let
  all_outputs = (pkgs.writeShellScriptBin "all_outputs" ''
    # NixOS systems - x86_64-linux
    echo ${self.nixosConfigurations.aida.config.system.build.toplevel}
    echo ${self.nixosConfigurations.daisy.config.system.build.toplevel}
    echo ${self.nixosConfigurations.deke.config.system.build.toplevel}
    echo ${self.nixosConfigurations.kora.config.system.build.toplevel}
    echo ${self.nixosConfigurations.simmons.config.system.build.toplevel}
    echo ${self.nixosConfigurations.snowflake.config.system.build.toplevel}
    echo ${self.nixosConfigurations.the-bus.config.system.build.toplevel}
    echo ${self.nixosConfigurations.the-hub.config.system.build.toplevel}
  '');
in
pkgs.writeShellScriptBin "build_outputs" ''
  # makes sure we don't garbage collect the build outputs
  ln -sfn ${all_outputs} ~/.keep-nix-outputs-MayNiklas

  # print the size of the build outputs
  nix path-info --closure-size -h ${all_outputs}

  # push outputs to attic when attic is available
  if command -v attic &> /dev/null
  then
    attic push lounge-rocks:nix-cache ${all_outputs}
  else
    echo "attic not available"
  fi
''
