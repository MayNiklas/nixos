{ writeShellScriptBin, nix, github-copilot-intellij-agent, ... }:
writeShellScriptBin "pycharm-fix" ''
  for f in ~/.local/share/JetBrains/*; do
    if [[ $f == *"PyCharm"* ]]; then
      ${nix}/bin/nix-store --add-root $f/copilot-agent-linux -r ${github-copilot-intellij-agent}/bin/copilot-agent
      echo "Created link from $f/copilot-agent-linux to ${github-copilot-intellij-agent}/bin/copilot-agent..."
    fi
  done
''
