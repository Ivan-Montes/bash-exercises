#!/bin/bash
set -euo pipefail
#set -x

show_user() {

  local user="$1"
  local user_tty="$2"
  
  echo -e "\tHello user $user. You are connected on TTY $user_tty"
}

show_date() {
  
  local current_date=""
  current_date=$(date +"%Y-%m-%d %T")
  
  echo -e "\tDate => $current_date"
}

show_connected_users() {

  local connected_users=""
  connected_users=$(users)
  
  echo -e "\tConnected Users => $connected_users"
}

show_user_process() {

  local user="$1"
  local -a user_process=()
  mapfile -t user_process < <(ps -u "$user" -o user,pid,comm)
  
  echo -e "\t=== Process list ==="
  for line in "${user_process[@]}"; do
    echo -e "\t$line"
  done  
}

main() {

  local user=""
  user=$(whoami)
  local user_tty=""
  user_tty=$(tty)
  
  show_user "$user" "$user_tty"
  show_date
  show_connected_users
  show_user_process "$user"
}

main "$@"

