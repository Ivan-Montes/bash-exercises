#!/bin/bash
set -euo pipefail
#set -x


validate_params() {

  if [ $# -lt 2 ]; then
    echo -e "\tParams number less than 2" >&2
    exit 0
  fi

}

should_return_two_params() {

  local first_param="${1}"
  local last_param
  last_param=$(get_last_param "${@}")

  echo -e "\tFirst param is $first_param"
  echo -e "\tLast param is $last_param"

}

get_last_param() {

  local final_param=""

  for param in "${@}"; do

    final_param="${param}"

  done

  echo "${final_param}"

}

main() {

  validate_params "${@}"
  should_return_two_params "${@}"

}


main "${@}"
