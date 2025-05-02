#!/bin/bash
set -euo pipefail
#set -x


validate_params() {

  validate_param_number "${@}"
  validate_param_string "${@}"
  validate_param_archives "${@}"

}

validate_param_number() {

  if (( $# < 2 )); then
    echo -e "\tError: Two parameters minimum are required." >&2
    return 1
  fi

}

validate_param_string() {

  local string="${1}"
  if [ -z "${string}" ]; then
    echo -e "\tError: The first parameter cannot be empty" >&2
    return 1
  fi

}

validate_param_archives() {

  for (( i=2; i<=$#; i++ )); do

    local archive="${!i}"

    if ! [ -r "${archive}" ]; then
      echo -e "\tError: The parameter must be a readable file: $archive" >&2
      return 1
    fi

    if ! [ -f "${archive}" ]; then
      echo -e "\tError: The parameter must be a regular file: $archive" >&2
      return 1
    fi

  done

}

search_string() {

  local string="${1}"  
  local -a coincidences_list=()

  for (( i=2; i<=$#; i++ )); do
    
    local archive="${!i}"

    if grep -qw "${string}" "${archive}"; then
      coincidences_list+=("${archive}")
    fi

  done

  printf "%s\n" "${coincidences_list[@]}"

}

print_header() {

  local string="${1}"
  echo -e "\tResult of searching the string \"${string}\" "

}

print_coincidences() {

  local -a coincidences_list=("${@}")
  local count=0
  for coincidence in "${coincidences_list[@]}"; do
    if [[ -n "$coincidence" ]]; then
      echo -e "\t - ${coincidence}"
      ((count+=1))
    fi
  done
  if (( count == 0 )); then
    echo -e "\t** There are no coincidences **"
  fi

}

main() {

  validate_params "${@}"
  local -a matches=()
  mapfile -t matches < <(search_string "$@")
  print_header "${@}"
  print_coincidences "${matches[@]}"

}

main "${@}"
