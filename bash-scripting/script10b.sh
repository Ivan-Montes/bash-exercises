#!/bin/bash
set -euo pipefail
#set -x


check_num_of_args() {

  if (( $# <= 1 )); then
    echo -e "\tError: At least two args are required." >&2
    exit 1
  fi
}

validate_param_string() {

  local string="$1"
  
  if [ -z "$string" ]; then
    echo -e "\tError: The first parameter must not be empty" >&2
    exit 1
  fi
  
  if [[ "$string" =~ ^[[:space:]]*$ ]]; then
    echo -e "\tError: The first parameter must not contain only whitespace" >&2
    exit 1
  fi
}

is_valid_file() {

  local archive="$1"
  
  if ! [[ -f "$archive" ]]; then
    echo -e "\tError: archive invalid => $archive" >&2
    return 1
  fi
  
  if ! [[ -r "$archive" ]]; then
    echo -e "\tError: READ permission is required => $archive" >&2
    return 1
  fi
  
  if ! [[ -s "$archive" ]]; then
    echo -e "\tError: empty archive => $archive" >&2
    return 1
  fi
}

check_array_content() {

  local -a arr=("$@")
  for item in "${arr[@]}"; do
    if [[ -n "$item" ]]; then
      return 0
    fi
  done
  return 1
}

search_string() {

  local string="$1"
  local files=("${@:2}")
  local -a result=()
  
  for archive in "${files[@]}"; do
    if ! is_valid_file "$archive"; then
      break
    fi
    if grep -wq "$string" "$archive"; then
      result+=("$archive")
    fi
  done

  printf "%s\n" "${result[@]}"
}

print_result() {

  local string="$1"
  shift
  local -a files=("$@")

  if (( "${#files[@]}" == 0 )); then
    echo -e "\tInfo: Non coincidences"
    exit 0
  fi
  
  if ! check_array_content "${files[@]}"; then
    echo -e "\tInfo: Non coincidences"
    exit 0
  fi
  
  echo -e "\tThe string [${string}] has been found in these files:"
  
  for archive in "${files[@]}"; do
    echo -e "\t [x] $archive"
  done
}

main() {

  check_num_of_args "$@"
  validate_param_string "$@"
  local -a result=()
  mapfile -t result < <(search_string "$@")
  print_result "$1" "${result[@]}"  
}

main "$@"

