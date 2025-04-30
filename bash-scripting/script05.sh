#!/bin/bash
set -euo pipefail
#set -x



validate_params() {

  if (( $# != 1 )); then
    echo -e "\tExactly One parameter is necessary" >&2
    return 1
  fi

  local param1="${1}"
  if ! [[ "${param1}" =~ ^[0-9]+$ ]]; then
    echo -e "\tParam must be a positive number" >&2
    return 1
  fi  

  if ! (( param1 <= 10 )); then
    echo -e "\tParam between 1 and 10" >&2
    return 1
  fi

}

print_header() {

  local num=$1
  echo -e "\tMultiplication table of $num"

}

print_separator(){
  echo -e "\t============================"
}

generate_list() {

  local num=$1

  for ((i=1; i<=10; i++)); do

    local result=$(( num * i ))
    echo -e "\t\t$num * $i = $result" 

  done

}

main() {

  validate_params "${@}"
  print_header "${@}"
  print_separator
  generate_list "${@}"

}

main "${@}"
