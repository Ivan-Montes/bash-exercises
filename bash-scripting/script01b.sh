#!/usr/bin/env bash
set -euo pipefail
#set -x


validate_arguments() {

  validate_argument_number "$@"
}

validate_argument_number() {

  if (( $# == 0 )); then
    echo "The initial and final argument are missing" >&2
    exit 1
  fi
  
  if (( $# == 1 )); then
    echo "The final argument is missing" >&2
    exit 1
  fi
}

handle_arguments() {

  local first_arg="$1"
  local last_arg="${*: -1}"

  printf "%s\n%s"  "$first_arg" "$last_arg"
}

print_arguments(){

  local first_arg="$1"
  local last_arg="$2"
  echo "The first argument is $first_arg"  
  echo "The last argument is $last_arg"
}

main() {

  validate_arguments "$@"
  local args_array=()
  mapfile -t args_array < <(handle_arguments "$@")
  print_arguments "${args_array[@]}"
}

main "$@"

