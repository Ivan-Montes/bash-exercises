#!/bin/bash
set -euo pipefail
#set -x


print_deco_line_1() {
  echo -e '\t========================='
}

print_main_header() {

  clear
  print_deco_line_1
  echo -e "\t\t Agenda"
  print_deco_line_1
  echo
}

print_help() {

  echo
  echo -e "\t ${1-'Help Function'}"
  echo
  echo -e "\t Usage: script15.sh [DB]\n"
  echo -e "\t [DB] \t Path to the database (optional)."
  echo -e "\t If no database is specified, it will be created by default in /tmp"
  echo

}

print_menu_options() {

  echo
  echo -e "\t h) Show help"
  echo -e "\t q) Exit the agenda"
  echo -e "\t l) List agenda content"
  echo -e "\t on) Sort by name (ascending)"
  echo -e "\t os) Sort by balance (descending)"
  echo -e "\t a) Add a new entry"
  echo -e "\t b) Delete an entry"
  echo
}

print_list_header() {

  echo && printf "%18s %18s %12s %12s\n" "Name" "City" "Balance" "Phone" && echo

}

press_key_to_continue() {

  echo -e "\n"
  read -n 1 -s -r -p '	Press any key to continue '
  sleep 0.3s

}

validate_param_number() {

  if (( $# > 2 )); then
    echo "-e \tError: Expected a maximun of 2 arguments." >&2
    return 1
  fi

}

check_database_arg() {

 local database="${1}"
 local default_database="agenda.dat"

  if [[ -z "$database" ]]; then
    database="${default_database}"
    touch "${database}"
  fi

  echo "${database}"

}

validate_database_file() {

  local archive="${1}"

  if [[ ! -f "${archive}" ]]; then
    echo -e "\tError: The database must be a regular file: $archive" >&2
    return 1
  fi

  if [[ ! -r "${archive}" ]]; then
    echo -e "\tError: The database must be a readable file: $archive" >&2
    return 1
  fi

  if [[ ! -w "${archive}" ]]; then
    echo -e "\tError: The database must be a writable file: $archive" >&2
    return 1
  fi

}

validate_string_data() {

  local value="${1}"
  local field="${2}"

  if [[ -z "${value}" ]]; then
    echo -e "\tThe field ${field} cannot be empty." >&2
    echo 1
  else
    echo 0
  fi
  
}

validate_number_data() {

  local value="${1}"
  local field="${2}"

  if [[ ! "${value}" =~ ^[0-9]+$ ]]; then
    echo -e "\tInvalid numeric value in field '${field}': '${value}'" >&2
    echo 1
  else
    echo 0
  fi
  
}

bye() {

  local -i i
  sleep 0.3s
  for i in {2..0}
    do
      clear
      echo -e "\t \t \tQuit in ${i}s"
      sleep 1s
    done

}

list_agenda() {

  local db="${1}"

  validate_database_file "${db}"

  while IFS=":" read -r name city balance phone; do
    printf "%18s %18s %12s %12s\n" "$name" "$city" "$balance" "$phone"
  done < "${db}"

}

order_by_name_asc() {

  local db="${1}"
  local db_name="${db##*/}"
  local temp_db
  temp_db="$(mktemp /tmp/db_tmp.XXXXXX)"

  validate_database_file "${db}"
  sort -t ":" -k1 "${db}" > "${temp_db}" && mv "${db}" "/tmp/${db_name}_backup" && mv "${temp_db}" "${db}"

}

order_by_money_desc() {

  local db="${1}"
  local db_name="${db##*/}"
  local temp_db
  temp_db="$(mktemp /tmp/db_tmp.XXXXXX)"

  validate_database_file "${db}"
  sort -t ":" -k3nr "${db}" > "${temp_db}" && mv "${db}" "/tmp/${db_name}_backup" && mv "${temp_db}" "${db}"

}

add_record() {

  local db="${1}"
  local -a keys=("Name" "City" "Balance" "Phone")
  local -A values
  local errors=0
  local retry="y"

  while [[ "${retry}" == "y" ]]; do
    errors=0

    for key in "${keys[@]}"; do
      local value
      value=$(ask_data "${key}")
      values["$key"]="${value}"
    done

    (( errors += $(validate_string_data "${values[Name]}" "${keys[0]}") ))
    (( errors += $(validate_string_data "${values[City]}" "${keys[1]}") ))
    (( errors += $(validate_number_data "${values[Balance]}" "${keys[2]}") ))
    (( errors += $(validate_number_data "${values[Phone]}" "${keys[3]}") ))


    if (( errors == 0 )); then
      
      echo "${values[Name]}:${values[City]}:${values[Balance]}:${values[Phone]}" >> "$db"
      echo -e "\n\tRecord successfully added."
      retry="n"
      
    else
     
      echo -e "\n\t${errors} validation error(s) detected."
      read -rp "	Do you want to try again? (y/n): " retry
      retry="${retry,,}"
      
      if [[ "${retry}" != "y" ]]; then
        echo "	Operation canceled. Returning to menu."
      fi
      
    fi
    
  done
  
}

ask_data() {

  local key="${1}"
  local value=""

  read -rp "   Please, enter ${key} " value
  echo "${value}"

}

del_record() {

  local db="${1}"
  local name=""
  local question_name="Name to delete: "
  local are_sure="	Are you sure? y/n "
  local confirm=""
  
  name=$(ask_data "${question_name}")
  
  echo -e "\n	Proceeding to delete the record for user |$name|\n"
  
  read -n 1 -rp  "${are_sure}" confirm
  confirm="${confirm,,}"
  
  if [[ "${confirm}" == "y" ]]; then
  
    if delete_user_from_db "${db}" "${name}"; then
      echo -e "\n\n\tRecord |$name| deleted."
    else
      echo -e "\n\n\tRecord |$name| not found."
    fi
  
  else
    echo -e "\n\tUser deletion cancelled for |${name}|."
  fi

}

delete_user_from_db() {

  local db="${1}"
  local name="${2}"

  grep -w "${name}" "${db}" >/dev/null && sed -i.bak "/${name}/d" "${db}"
  
}

menu() {

  local db="${1}"
  local option=""

  while [[ "${option}" != "q" && "${option}" != "Q" ]]; do

    print_main_header && print_menu_options
    read -rp "	Please, select an option " option
    option="${option//[^[:alnum:]]/}"
    case "${option}" in
    h | H) print_help && press_key_to_continue
    ;;
    q | Q) bye
    ;;
    l | L) print_list_header && list_agenda "${db}" && press_key_to_continue
    ;;
    on | ON) order_by_name_asc "${db}" && press_key_to_continue
    ;;
    os | OS) order_by_money_desc "${db}" && press_key_to_continue
    ;;
    a | A) add_record "${db}" && press_key_to_continue
    ;;
    b | B) del_record "${db}" && press_key_to_continue
    ;;
    *) echo -e "\tWrong option, try again"
    sleep 1s
    ;;
    esac
  done

}

handle_args() {

  local original_params=("$@")
  local -a positional_args=()
  local database=""

  while (( $# > 0 )); do
    case "${1}" in
      -h)
        print_help
        exit 1
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

  database="${positional_args[0]:-}"
  echo "${database}"

}

main() {

  local database=""
  validate_param_number "${@}"
  database=$(handle_args "${@}")
  database=$(check_database_arg "${database}")
  validate_database_file "${database}"
  menu "${database}"

}

main "${@}"
