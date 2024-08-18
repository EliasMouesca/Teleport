#!/bin/sh
tp() {
  TP_BIN="/home/$USER/datos/GoProjects/Teleport/tpbin"
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

