{ writeShellScriptBin, nix, github-copilot-intellij-agent, fetchurl, ... }:
let
  my-github-copilot-intellij-agent = github-copilot-intellij-agent.overrideAttrs (oldAttrs: rec {
    pname = "github-copilot-intellij-agent";
    version = "1.4.5.4049";
    src = fetchurl {
      name = "${pname}-${version}-plugin.zip";
      url = "https://plugins.jetbrains.com/plugin/download?updateId=454005";
      hash = "sha256-ibu3OcmtyLHuumhJQ6QipsNEIdEhvLUS7sb3xmnaR0U=";
    };
  });
in
writeShellScriptBin "pycharm-fix" ''
  for f in ~/.local/share/JetBrains/*; do
    if [[ $f == *"PyCharm"* ]]; then
      ${nix}/bin/nix-store --add-root $f/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux -r ${my-github-copilot-intellij-agent}/bin/copilot-agent
      echo "Created link from $f/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux to ${my-github-copilot-intellij-agent}/bin/copilot-agent..."
    fi
  done
''
