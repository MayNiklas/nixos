{ pkgs, ... }:
pkgs.writeShellScriptBin "gen-module" ''
    #!/usr/bin/env bash
    # Generate a new module for nixos
    # Usage: gen-module <module-name>
    # Example: gen-module my-module
    # This will create a new module in $(pwd)/modules/my-module/default.nix.

    if [ -z "$1" ]; then
      echo "Usage: gen-module <module-name>"
      exit 1
    fi

    module_name=$1
    module_file="$(pwd)/modules/$module_name/default.nix"

    if [ -f "$module_file" ]; then
      echo "Module $module_name already exists"
      exit 1
    fi

    echo "Creating module $module_name"

    mkdir -p "$(pwd)/modules/$module_name"
    cp --no-preserve=mode,ownership ${(pkgs.writeText "default.nix" ''
    { pkgs, lib, config, ... }:
    with lib;
    let cfg = config.mayniklas.my-module;
    in
    {

      options.mayniklas.my-module = {
        enable = mkEnableOption "activate my-module";
      };

      config = mkIf cfg.enable { };

    }
  '')} $module_file
  # replace my-module with module name in file
  sed -i "s/my-module/$module_name/g" $module_file
    
  git add $module_file
''
