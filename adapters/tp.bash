_tp_complete() {
    COMPREPLY=($(compgen -W "$(basename -a /home/$USER/.config/Teleport/locations/* 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _tp_complete tp

tp() {
  TP_BIN="/home/$USER/datos/GoProjects/Teleport/tpbin"

  if [ -p /dev/stdin ] || [ "$BASH_SUBSHELL" -gt 0 ]; then
    export TP_BEING_PIPED="1"
  else
    export TP_BEING_PIPED="0"
  fi

  output=$("$TP_BIN" "$@")
  exit_status=$?

  case $exit_status in
      0) # 0 Means "cd to there"
          cd "$output" || exit
          ;;

      1) # 1 Means "Print to stdout, normal execution"
          echo "$output"
          ;;
      2) # 2 Means "Print to stderr, there was an error"
          >&2 echo "$output"
          ;;
      *) # Should not happen
          >&2 echo "This should not be happening"
          ;;
  esac
}

