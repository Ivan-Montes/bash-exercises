#!/bin/bash
set -euo pipefail
#set -x


print_help() {
  echo
  echo "Options:"
  echo "  -i    Invert the diffd behavior, showing only files common to both directories."
  echo
  echo "Arguments:"
  echo "  dir1   Mandatory directory to compare."
  echo "  dir2   Optional directory. Defaults to the current directory if not provided."
  echo
  echo "Description:"
  echo "  Compares files in two directories. If -i is used, only common files are shown."
}

validate_params() {

  local dir1="${1}"
  validate_directory "${dir1}"
  local dir2="${2}"
  validate_directory "${dir2}"

}

validate_param_number() {

  if (( $# < 1 || $# > 3 )); then
    echo "Error: expected between 1 and 3 positional arguments." >&2
    return 1
  fi

}

extract_dir2() {

  local dir2
  dir2=$(pwd)

 if (( $# >= 2 )); then
    dir2="${2}"
  fi

  echo "${dir2}"

}

validate_directory() {

  local directory="${1}"

  if [[ ! -d "${directory}" ]]; then
    echo "Error: Not a directory: ${directory}" >&2
    return 1
  fi

  if [[ ! -r "${directory}" ]]; then
    echo -e "\tError: The directory must be readable: $directory" >&2
    return 1
  fi

  if [[ ! -x "${directory}" ]]; then
    echo -e "\tError: The directory must be executable: $directory" >&2
    return 1
  fi

}

generate_file_list() {

  local -n files_array="$1"
  local dir="${2}"
  mapfile -t files_array < <(find "${dir}" -mindepth 1 -maxdepth 1 -type f -printf "%f\n" | sort -V )

}

generate_comparison() {

  local show_files_both_dirs="${1}"
  local -n dir1_array_rf="${2}"
  local dir1="${3}"
  local -n dir2_array_rf="${4}"
  local dir2="${5}"
  local -a comparison_array=()

  if [[ "${show_files_both_dirs}" == false ]]; then
    mapfile -t comparison_array < <(generate_comparison_regular dir1_array_rf "${dir1}" dir2_array_rf "${dir2}")
  else
    mapfile -t comparison_array < <(generate_comparison_inverse dir1_array_rf dir2_array_rf)
  fi

  printf "%s\n" "${comparison_array[@]}"

}

generate_comparison_regular() {

  local -n dir1_array_sbrf="${1}"
  local dir1="${2}"
  local -n dir2_array_sbrf="${3}"
  local dir2="${4}"
  local -a comparison_array=()

  mapfile -t comparison_array < <(
    find_missing_files dir1_array_sbrf dir2_array_sbrf "${dir1}"
    find_missing_files dir2_array_sbrf dir1_array_sbrf "${dir2}"
  )

  printf "%s\n" "${comparison_array[@]}"
  
}

find_missing_files() {

  local -n source_array="${1}"
  local -n target_array="${2}"
  local dir_label="${3}"
  local -a missing=()

  for file in "${source_array[@]}"; do
    local found=false
    for ref_file in "${target_array[@]}"; do
      if [[ "${file}" == "${ref_file}" ]]; then
        found=true
        break
      fi
    done
    if [[ "${found}" == false ]]; then
      missing+=("${file} -> ${dir_label}")
    fi
  done

  printf "%s\n" "${missing[@]}"
  
}

generate_comparison_inverse() {

  local -n dir1_array_sbrf="${1}"
  local -n dir2_array_sbrf="${2}"
  local -a comparison_array=()
  declare -A file_lookup=()

  for file in "${dir2_array_sbrf[@]}"; do
    file_lookup["$file"]=1
  done

  for file in "${dir1_array_sbrf[@]}"; do
    if [[ -n "${file_lookup[$file]:-}" ]]; then
      comparison_array+=("${file}")
    fi
  done

  printf "%s\n" "${comparison_array[@]}"

}

print_result() {

  local -a results=("${@}")
  local count=0
  echo  ""
  for coincidence in "${results[@]}"; do
    if [[ -n "$coincidence" ]]; then
      echo -e "\t - ${coincidence}"
      ((count+=1))
    fi
  done
  if (( count == 0 )); then
    echo -e "\t** There are no results **"
  fi
  echo ""

}

handle_args() {

  local original_params=("$@")
  local -a positional_args=()
  local show_files_both_dirs=false
  local dir1=""
  local dir2=""
  local -a dir1_file_list=()
  local -a dir2_file_list=()
  local -a comparison_array=()

  while (( $# > 0 )); do
    case "${1}" in
      -i)
        show_files_both_dirs=true
        shift
        ;;
      -*)
        echo -e "\nUnknown option: ${1}"
        print_help
        exit 1
        ;;
      *)
        positional_args+=("${1}")
        shift
        ;;
    esac
  done

  dir1="${positional_args[0]}"
  dir2=$(extract_dir2 "${positional_args[@]}")
  validate_params "${dir1}" "${dir2}"
  generate_file_list dir1_file_list "${dir1}"
  generate_file_list dir2_file_list "${dir2}"
  mapfile -t comparison_array < <(generate_comparison "${show_files_both_dirs}" dir1_file_list "${dir1}" dir2_file_list "${dir2}")
  print_result "${comparison_array[@]}"

}

main() {

  validate_param_number "${@}"
  handle_args "${@}"

}

main "${@}"
