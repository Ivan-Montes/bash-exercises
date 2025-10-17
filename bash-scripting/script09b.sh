#!/bin/bash
set -euo pipefail
#set -x


check_num_of_args() {

  if (( $# <= 0 )); then
    echo -e "\tError: At least one arg is required." >&2
    exit 1
  fi
  
  if (( $# > 2 )); then
    echo -e "\tError: Max of args reached." >&2
    exit 1
  fi
}

exists_user() {

  local user="$1"
  
  if ! id "$user" &>/dev/null; then
    echo -e "\tError: User [$user] does not exist." >&2
    exit 2
  fi
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

display_user_info() {

  local user="$1"
  local full_name=""
  local home_dir=""
  local shell_name=""
  local is_connected=""  
  
  full_name=$(getent passwd "$user" | cut -d ':' -f 5 | cut -d ',' -f 1)
  home_dir=$(getent passwd "$user" | cut -d ':' -f 6)
  shell_name=$(getent passwd "$user" | cut -d ':' -f 7)
  is_connected=$(who | grep -wq "^${user}" && echo "Connected" || echo "Not connected")
  
  echo -e "\tLogin Name: $user"
  echo -e "\tFull Name: $full_name"
  echo -e "\tHome Directory: $home_dir"
  echo -e "\tLogin Shell: $shell_name"
  echo -e "\tConnection Status: $is_connected"
}

display_user_process() {

  local user="$1"
  local -a user_process=()
  mapfile -t user_process < <(ps -u "$user" -o pid,comm)
  
  echo -e "\t=== Process list ==="
  for line in "${user_process[@]}"; do
    echo -e "\t$line"
  done  
}

manage_info() {

  local user="$1"
  local args=("${@:2}")
  local show_only_process="${args[0]}"
  local show_all_except_process="${args[1]}"

  if [[ "$show_only_process" == "true" ]]; then
    display_user_process "$user"
    exit 0
  fi
  
  if [[ "$show_all_except_process" == "true" ]]; then
    display_user_info "$user"
    exit 0
  fi
  
  display_user_info "$user"
  display_user_process "$user"
}

handle_args() {

  local -a option_list=()
  local show_only_process="false"
  local show_all_except_process="false"
  local user_name="?"
    
  while (( $# > 0 )); do
    case "$1" in
      -p)
        show_only_process="true"
        shift
        ;;
      -u)
        show_all_except_process="true"
        shift
        ;;
      --help|-h)
        print_help  >&2
        exit 0
        ;;
      -*)
        echo -e "\tError: Unknown option: $1" >&2
        print_help  >&2
        exit 1
        ;;
      *)
        user_name="$1"
        shift
        ;;
    esac
  done

  option_list=("$user_name" "$show_only_process" "$show_all_except_process")  
  exists_user "${option_list[0]}"
  manage_info "${option_list[@]}"
}

main() {

  check_num_of_args "$@"
  handle_args "$@"
}

main "$@"

