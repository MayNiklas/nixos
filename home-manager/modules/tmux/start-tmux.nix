{ writeShellScriptBin
, tmux
, ...
}:
writeShellScriptBin "start-tmux" ''
  # if parameter is given, use it as session name
  if [ $# -eq 1 ]; then
    tmux_session_name=$1
  else
    tmux_session_name="default-session"
  fi

  # start tmux session if not already running
  if ! ${tmux}/bin/tmux has-session -t $tmux_session_name; then
    echo "$tmux_session_name not running, starting it..."
    ${tmux}/bin/tmux new-session -d -s $tmux_session_name
  else
    echo "$tmux_session_name already running..."
  fi

  # attach to tmux session
  sleep 1
  echo "Attaching to tmux session $tmux_session_name"
  ${tmux}/bin/tmux attach-session -t $tmux_session_name
''
