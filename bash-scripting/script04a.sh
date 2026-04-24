#!/bin/bash
set -euo pipefail
#set -x


ask_number() {

  read -r -p "Enter a number to calculate its double: " number
  echo "${number}"

}

validate_params() {

  local param1="${1}"

  if [ $# -lt 1 ]; then
    echo -e "\tThere are no parameters" >&2
    return 1
  fi

  if ! [[ "${param1}" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    echo -e "\tParam must be a number" >&2
    return 1
  fi  

}

calc_double() {

  local number=$1
  local result
  result=$(echo "scale=2; $number * 2" | bc)

  echo "${result}"

}

show_result(){

  local number=$1
  local result=$2

  echo -e "\tThe double of $number is $result"

}

ask_for_another_number() {

  read -r -p "Do you want to calculate another number (Y/N) ?: " answer

  if [[ "${answer}" =~ ^(y|Y|yes|YES|Yes)$ ]]; then
    echo 1
  else
    echo 0
  fi

}

menu(){

  local sentry=1

  while (( sentry == 1 )); do

    local number
    number=$(ask_number)
    validate_params "${number}"
    local result
    result=$(calc_double "${number}")
    show_result "${number}" "${result}"

    sentry=$(ask_for_another_number)

  done

}

main() {

  menu

}

main "${@}"
