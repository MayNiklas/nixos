{ pkgs, github-copilot-intellij-agent, ... }:
pkgs.writeShellScriptBin "pycharm-fix" ''
  for f in ~/.local/share/JetBrains/*; do
    if [[ $f == *"PyCharm"* ]]; then
      ln -s ${github-copilot-intellij-agent}/bin/copilot-agent $f/copilot-agent-linux
    fi
  done
''
