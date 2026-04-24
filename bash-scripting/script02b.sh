#!/usr/bin/env bash
set -euo pipefail
#set -x


validate_arguments() {

  validate_arguments_number "$@"
}

validate_arguments_number() {

  if (( $# <= 0 )); then
    printf "%s\n" "No arguments were passed" >&2
    exit 1
  fi  
}

print_arguments() {

  local element
  local -i i=0
  for element in "$@"; do
    ((i+=1))
    printf "ARGUMENT NUMBER %s: %s\n" "$i" "$element"
  done
}

main() {

  validate_arguments "$@"
  print_arguments "$@"
}

main "$@"

