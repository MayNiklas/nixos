{ writeShellScriptBin, zellij, ... }:
writeShellScriptBin "start-zellij" ''
  ${zellij}/bin/zellij attach -c
''
