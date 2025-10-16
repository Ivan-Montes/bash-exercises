#!/bin/bash
set -euo pipefail
#set -x

validate_route() {
  local route="$1"

  if ! [[ -d "$route" ]]; then
    echo -e "\tError: Path must be a valid directory: $route" >&2
    exit 1
  fi
}

list_content() {
  local route="$1""/*"
  local -a files_list=()  
  mapfile -t files_list < <(file $route)

  printf "%s\n" "${files_list[@]}"
}

analyze_files() {
  local -a ex_list=()
  local -a dir_list=()
  local -a text_list=()
  local -a other_list=()
  local route="$1"
  local files=("${@:2}")

  for line in "${files[@]}"; do
    local name=""
    name=$(echo "$line" | cut -d':' -f1)
    local description=""
    description=$(echo "$line" | cut -d':' -f2)

    if [[ "$description" == *"executable"* ]]; then
      ex_list+=("$name")

    elif [[ "$description" == *"ASCII text"* ]]; then
      text_list+=("$name")

    elif [[ "$description" == *"directory"* ]]; then
      dir_list+=("$name")

    else
      other_list+=("$name")
    fi    
  done

  print_result "$route" text_list dir_list ex_list other_list
}

print_result() {
  local route="$1"
  local -n text_list_rf=$2
  local -n dir_list_rf=$3
  local -n ex_list_rf=$4
  local -n other_list_rf=$5

  echo -e "\tFile listing for path => $route"
  echo -e "\t======================================="
  echo -e "\tFound ${#text_list_rf[@]} text files: $(printf "%s, " "${text_list_rf[@]}" | sed 's/, $//')"
  echo -e "\tFound ${#dir_list_rf[@]} directories: $(printf "%s, " "${dir_list_rf[@]}" | sed 's/, $//')"
  echo -e "\tFound ${#ex_list_rf[@]} executables: $(printf "%s, " "${ex_list_rf[@]}" | sed 's/, $//')"
  echo -e "\tFound ${#other_list_rf[@]} others: $(printf "%s, " "${other_list_rf[@]}" | sed 's/, $//')"
}

main() {
  local default_route="."
  local route="${1:-$default_route}"  
  validate_route "$route"

  local -a files=()
  mapfile -t files < <(list_content "$route")
  analyze_files "$route" "${files[@]}"
}

main "${@}"

