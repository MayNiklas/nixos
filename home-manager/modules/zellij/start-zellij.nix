{ writeShellScriptBin
, zellij
, fzf
, ...
}:
writeShellScriptBin "start-zellij" ''
  ZJ_SESSIONS=$(${zellij}/bin/zellij list-sessions -n)
  NO_SESSIONS=$(echo "$ZJ_SESSIONS" | wc -l)
  if [ "$NO_SESSIONS" -ge 2 ]; then
    ${zellij}/bin/zellij attach "$(echo "$ZJ_SESSIONS" | ${fzf}/bin/fzf | cut -d' ' -f1)"
  else
    ${zellij}/bin/zellij attach -c
  fi
''
