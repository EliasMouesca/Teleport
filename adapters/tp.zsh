_tp_complete() {
    local locations
    locations=($(basename -a /home/$USER/.config/Teleport/locations/* 2>/dev/null))
    compadd -a locations
}

compdef _tp_complete tp

tp() {
  TP_BIN="/path/to/tpbin"
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

