#!/bin/bash
set -euo pipefail
#set -x


validate_params() {

  if (( $# != 2 )); then
    echo -e "\tError: Exactly two parameters are required." >&2
    return 1
  fi

  local archive="${1}"
  if ! [ -r "${archive}" ]; then
    echo -e "\tError: The first parameter must be a readable file: $archive" >&2
    return 1
  fi

  local directory="${2}"
  if ! [ -d "${directory}" ]; then
    echo -e "\tError: The second parameter must be a directory: $directory" >&2
    return 1
  fi

  if ! [ -w "${directory}" ]; then
    echo -e "\tError: The directory must be writable: $directory" >&2
    return 1
  fi

}

copy_file() {

  local archive="${1}"
  local directory="${2}"

  echo -e "\tCopy ${archive} to ${directory}"
  cp "${archive}" "${directory}" && echo -e "\tCopy successfully" || echo -e "\tError on copy process"

}

main() {

  validate_params "${@}"
  copy_file "${@}"

}

main "${@}"
