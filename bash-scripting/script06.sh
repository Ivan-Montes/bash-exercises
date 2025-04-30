#!/bin/bash
set -euo pipefail
#set -x


extract_directory() {

  if (( $# == 0 )); then
    local current_folder
    current_folder=$(pwd)
    echo "${current_folder}"
  fi

  if (( $# == 1 )); then
    local param1="${1}"
    echo "${param1}"
  fi

  if (( $# >= 2 )); then
    echo -e "\tNumber of Parameters allowed between 0 and 1" >&2
    return 1
  fi

}

validate_directory() {

  local directory="${1}"

  if ! [ -r "${directory}" ]; then
    echo -e "\tError: The directory must be readable: $directory" >&2
    return 1
  fi

  if ! [ -x "${directory}" ]; then
    echo -e "\tError: The directory must be executable: $directory" >&2
    return 1
  fi

}

count() {

  local directory="${1}"
  local -a files_array
  mapfile -t files_array < <(find "${directory}" -mindepth 1 -maxdepth 1)
  local -a txt_file_names=()
  local -a directory_names=()
  local -a exec_file_names=()
  local -a unknown_names=()

  for f in "${files_array[@]}"; do
    local analized_file
    analized_file=$(file "${f}")
    if echo "${analized_file}" | grep -q "ASCII text" && ! echo "${analized_file}" | grep -q "executable"; then
      txt_file_names+=("${f##*/}")
    elif echo "${analized_file}" | grep -q "directory" ; then
      directory_names+=("${f}")
    elif echo "${analized_file}" | grep -q "executable" ; then
      exec_file_names+=("${f##*/}")
    else
      unknown_names+=("${f##*/}")
    fi
  done

  echo -e "\tClasification of folder ${directory} :"
  echo -e "\t==================================="
  echo -e "\tThere are ${#txt_file_names[@]} text files:\n $(printf "%s " "${txt_file_names[@]}")\n"
  echo -e "\tThere are ${#directory_names[@]} directories:\n $(printf "%s " "${directory_names[@]}")\n"
  echo -e "\tThere are ${#exec_file_names[@]} executable files:\n $(printf "%s " "${exec_file_names[@]}")\n"
  echo -e "\tThere are ${#unknown_names[@]} unknown files:\n $(printf "%s " "${unknown_names[@]}")\n"

}

main() {

  local directory
  directory=$(extract_directory "${@}")
  validate_directory "${directory}"
  count "${directory}"

}

main "${@}"
