#!/usr/bin/env bash
set -euo pipefail
#set -x


validate_number() {
  
  local candidate="${1:?'Error: Input not found'}"
  if ! [[ $candidate =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    printf "The number [%s] is not valid\n" "$candidate" >&2
    exit 1
  fi  
}

calculate_double() {

  local number=$1
  local result
  result=$(bc <<< "scale=2; $number * 2")
  
  printf "The double of %s is %s\n" "$number" "$result"
}

main() {

  while true; do
    printf "Enter a number to calculate its double: "
    local input
    read -r input
    validate_number "$input"
    calculate_double "$input"
    printf "Do you want to calculate another double (Y/N)? "
    local retry
    read -r retry
    if ! [[ $retry =~ ^[Yy]$ ]]; then
      break
    fi    
  done
}

main "$@"

