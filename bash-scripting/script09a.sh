#!/bin/bash
set -euo pipefail
#set -x


validate_user() {

  local username="${1}"

  if ! getent passwd "${username}" > /dev/null; then
    echo "Error: User ${username} does not exist."
    exit 1
  fi

}

prepare_info() {

  local user_name="${1}"
  local user_info_only="${2}"
  local show_processes="${3}"

  if [ "${user_info_only}" = true ]; then
    get_user_info "${user_name}"
  elif [ "${show_processes}" = true ]; then
    get_process_info "${user_name}"
  else
    get_user_info "${user_name}"
    get_process_info "${user_name}"
  fi

}

get_user_info() {

  local login_name="${1}"
  local full_name
  local home_directory
  local login_shell
  local connection_status

  full_name=$(getent passwd "${login_name}" | cut -d ':' -f 5 | cut -d ',' -f 1)
  home_directory=$(getent passwd "${login_name}" | cut -d ':' -f 6)
  login_shell=$(getent passwd "${login_name}" | cut -d ':' -f 7)
  connection_status=$(who | awk '{print $1}' | grep -wq "${login_name}" && echo "Connected" || echo "No")

  print_info "Login Name" "${login_name}"
  print_info "Full Name" "${full_name}"
  print_info "Home Directory" "${home_directory}"
  print_info "Login Shell" "${login_shell}"
  print_info "Connection Status" "${connection_status}"

}

get_process_info() {

  local login_name="${1}"
  local process_list
  process_list=$(ps -u "$login_name" -o pid=,comm=)
  print_process_list "${process_list}"

}

print_info() {
  local field_name="${1}"
  local field_value="${2}"
  echo -e "\t ${field_name}: ${field_value}"

}

print_process_list() {

  local process_list="${1}"

  echo -e "\t Process list:"
  while read -r process; do
    echo -e "\t - $process"
  done <<< "${process_list}"

}

print_help() {

  echo "Usage: $(basename "$0") [OPTIONS] [USER]"
  echo
  echo "OPTIONS:"
  echo "  -p        Show only process information"
  echo "  -u        Show all information except process-related data"
  echo "  --help    Show this help message"
  echo
  echo "PARAMETERS:"
  echo "  USER      The username for which to fetch information"
  echo
  echo "This script gathers and displays various information about a user."

}

handle_args() {

  local user_info_only=false
  local show_processes=false
  local user_name=""

  while (( $# > 0 )); do
    case "${1}" in
      -p)
        show_processes=true
        shift
        ;;
      -u)
        user_info_only=true
        shift
        ;;
      --help)
        print_help
        exit 0
        ;;
      -*)
        echo "Unknown option: ${1}"
        print_help
        exit 1
        ;;
      *)
        user_name="${1}"
        shift
        ;;
  esac
done

  validate_user "${user_name}"
  prepare_info "${user_name}" "${user_info_only}" "${show_processes}"

}

main() {

  handle_args "${@}"

}

main "${@}"
