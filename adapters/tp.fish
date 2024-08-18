function tp
  set TP_BIN "/home/eli/opt/Teleport/bin/tpbin"
  set output (eval $TP_BIN $argv)
  set exit_status $status

  switch $exit_status
    case 0
      # 0 Means "cd to there"
      cd "$output"
    case 1
      # 1 Means "Print to stdout, normal execution"
      string join \n $output
      return 0
    case 2
      # 2 Means "Print to stderr, there was an error"
      string join \n $output >&2
      return 1
    case '*'
      # Should not happen
      echo "This should not be happening" >&2
  end
end
