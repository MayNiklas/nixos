{ pkgs, github-copilot-intellij-agent, ... }:
pkgs.writeShellScriptBin "pycharm-fix" ''
  for f in ~/.local/share/JetBrains/*; do
    if [[ $f == *"PyCharm"* ]]; then
      echo "Fixing PyCharm at $f/copilot-agent-linux..."
      ln -s ${github-copilot-intellij-agent}/bin/copilot-agent $f/copilot-agent-linux
    fi
  done
''
