#!/bin/bash
set -euo pipefail
#set -x


validate_params() {

  if [ $# -lt 1 ]; then
    echo -e "\tThere are no parameters" >&2
    return 1
  fi

}

iterate_params() {

  local -i counter=0

  echo -e "\tSent parameters:"
  for param in "${@}";  do

    ((counter+=1))
    show_param $counter "${param}"

  done

}

show_param() {

  if [ $# -lt 2 ]; then
    echo "InvalidNumberOfArgumentsException" >&2
    return 1
  fi

  local param_number=$1
  local param_value="${2}"

  echo -e "\tParameter ${param_number}: ${param_value}" 

}

main() {

  validate_params "${@}"
  iterate_params "${@}"

}

main "${@}"
