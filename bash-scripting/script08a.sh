#!/bin/bash
set -euo pipefail
#set -x


generate_date() {

  read -r year month day hour minute <<< "$(date '+%Y %b %d %H %M')"

  echo "It's $hour hours and $minute minutes on the $day of $month, $year"

}

show_info() {

  local user
  local terminal
  local current_date
  local user_list
  local process_list 

  user=$(whoami)
  terminal=$(tty)
  current_date=$(generate_date)
  user_list=$(users | sort -u)
  process_list=$(ps u | awk 'NR > 1 {print $11}')

  print_user_info "${user}" "${terminal}"
  print_current_date "${current_date}"
  print_user_list "${user_list}"
  print_process_list "${process_list}"

}

print_user_info() {
  echo -e "\t Hello user ${1}, you are on terminal ${2}"
}

print_current_date() {
  echo -e "\t ${1}"
}

print_user_list() {
  echo -e "\t Connected user list: ${1}"
}

print_process_list() {

  local process_list="${1}"

  echo -e "\t Process list:"
  while read -r process; do
    echo -e "\t - $process"
  done <<< "${process_list}"

}

main() {

  show_info "${@}"

}

main "${@}"
