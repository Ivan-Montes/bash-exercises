#!/bin/bash
set -euo pipefail
#set -x


check_num_of_initial_args() {

  if (( $# == 0 )); then
    echo -e "\tError: At least one arg required." >&2
    exit 1
  fi
}

check_num_of_args() {

  if (( $# < 1 )); then
    echo -e "\tError: At least one arg required." >&2
    exit 1
  fi  
}

select_dirs() {

  local dir01="$1"
  local dir02="${2:-$(pwd)}"

  printf "%s\n" "$dir01" "$dir02"
}

validate_dirs() {

  local -a dirs=("$@")

  for dir in "${dirs[@]}"; do
    check_dir "$dir"  
  done  
}

check_dir() {

  local dir="$1"
  
  if ! [[ -d "$dir" ]]; then
    echo -e "\tError: Route must be a valid directory => $dir" >&2
    exit 1
  fi
  
  if ! [[ -r "$dir" ]]; then
    echo -e "\tError: READ permission is required => $dir" >&2
    exit 1
  fi
  
  if ! [[ -x "$dir" ]]; then
    echo -e "\tError: EXECUTE permission is required => $dir" >&2
    exit 1
  fi
}

compare_arrays() {

  local dir01="$1"
  local dir02="$2"  
  local -n dir01_list_rf=$3
  local -n dir02_list_rf=$4

  echo -e "\n\t== List of files in only one folder =="
  echo -e "\n\t## Only in folder [$dir01] ##"
  compare dir01_list_rf dir02_list_rf
  
  echo -e "\n\t## Only in folder [$dir02] ##"
  compare dir02_list_rf dir01_list_rf
}

compare() {
  
  local -n dir01_rf=$1
  local -n dir02_rf=$2
  local -i counter

  for file01 in "${dir01_rf[@]}"; do
    counter=0
    for file02 in "${dir02_rf[@]}"; do
      if [[ "$file01" == "$file02" ]]; then
        ((counter+=1))
        break
      fi      
    done
    if (( counter == 0 )); then
      echo -e "\t[x] $file01"
    fi
  done  
}

compare_arrays_inverse() {

  local dir01="$1"
  local dir02="$2"  
  local -n dir01_list_rf=$3
  local -n dir02_list_rf=$4

  echo -e "\n\t== List of files in both folders =="
  echo -e "\n\t## Folder 01: [$dir01] ##"
  echo -e "\t## Folder 02: [$dir02] ##\n"
  
  for file01 in "${dir01_list_rf[@]}"; do
    for file02 in "${dir02_list_rf[@]}"; do
      if [[ "$file01" == "$file02" ]]; then
        echo -e "\t[x] $file01 <==> $file02"
        break
      fi  
    done  
  done  
}

prepare_comparison() {

  local inverse="$1"
  local dir01="$2"
  local dir02="$3"  
  local -a dir01_list=()
  local -a dir02_list=()
  mapfile -t dir01_list < <(list_content "$dir01")
  mapfile -t dir02_list < <(list_content "$dir02")
  
  if [[ "$inverse" == "false" ]]; then
    compare_arrays "$dir01" "$dir02" dir01_list dir02_list
  else
    compare_arrays_inverse  "$dir01" "$dir02" dir01_list dir02_list
  fi
}

list_content() {

  local dir="$1"
  local -a files_list=()  
  mapfile -t files_list < <(find "$dir" -mindepth 1 -maxdepth 1 -type f -printf "%f:%s\n")

  printf "%s\n" "${files_list[@]}"
}

handle_args() {

  local inverse="false"
  
  while getopts ":i" opt; do
    case "$opt" in
      i)
      inverse="true"
      ;;
      \?)
      echo "Error: invalid option [-$OPTARG]" >&2
      exit 1
      ;;
    esac
  done

  shift $((OPTIND - 1))
  check_num_of_args "$@"
  local -a dirs=()
  mapfile -t dirs < <(select_dirs "$@")
  validate_dirs "${dirs[@]}"
  prepare_comparison "$inverse" "${dirs[@]}"
}

main() {

  check_num_of_initial_args "$@"
  handle_args "$@"
}

main "$@"

