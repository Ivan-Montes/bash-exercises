#!/bin/bash
set -euo pipefail
#set -x


declare DATABASE=""
declare DEF_DB_ROUTE="/tmp/"
declare DEF_DB_NAME="agenda.dat"

print_deco_line() {

  echo -e '\t========================='
}

print_main_header() {

  clear
  print_deco_line
  echo -e "\t     CONTACT LIST"
  print_deco_line
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

  echo && printf "%18s %18s %12s %12s\n" "Name" "City" "Balance" "Phone"
}

press_key_to_continue() {

  echo -e "\n"
  read -n 1 -s -r -p '	Press any key to continue '
  sleep 0.3s
}

ask_data() {

  local key="$1"
  local value=""

  read -rp "   Please, enter $key " value
  echo "$value"
}

check_args() {

  if (( $# > 1 )); then
    echo "-e \tError: Expected a maximun of 1 arguments." >&2
    exit 1  
  fi
}

init_db() {
  
  local proposed_db_name="${1:-$DEF_DB_NAME}"
  local proposed_db="$DEF_DB_ROUTE$proposed_db_name"
  
  if [[ -f "$proposed_db" ]]; then
    echo -e "\Info: db already exists => $proposed_db" >&2
  else
    create_db "$proposed_db"
  fi  
  
  DATABASE="$proposed_db"
}

create_db(){
 
  local db="$1"
  if touch "$db"; then
    echo "-e \tInfo: Success creating DB." >&2
  else
    echo "-e \tError: Fail creating DB." >&2
    exit 1  
  fi
}

is_valid_file() {

  local archive="${1:-$DATABASE}"
  
  if ! [[ -f "$archive" ]]; then
    echo -e "\tError: archive invalid => $archive" >&2
    exit 1
  fi
  
  if ! [[ -r "$archive" ]]; then
    echo -e "\tError: READ permission is required => $archive" >&2
    exit 1
  fi
  
  if ! [[ -w "$archive" ]]; then
    echo -e "\tError: WRITE permission is required => $archive" >&2
    exit 1
  fi
}

bye() {
  
  echo 
  print_deco_line
  echo -e "\t   Bye!! See you soon!!"
  print_deco_line
  echo
}

list_db() {

  is_valid_file
  print_list_header
  
  while IFS=':' read -r name city balance phone; do
    printf "%18s %18s %12s %12s\n" "$name" "$city" "$balance" "$phone"
  done < "$DATABASE"  
}

order_by_name_asc() {

  local tmp_file
  tmp_file=$(mktemp /tmp/tmp_file_XXXXXX.dat) || return 1
  is_valid_file
  
  if ! sort -t ':' -k 1 "$DATABASE" > "$tmp_file"; then
    echo "Error: Failed to sort database." >&2
    rm -f "$tmp_file"
    return
  fi
  
  mv "$tmp_file" "$DATABASE"
}

order_by_balance_desc() {

  local tmp_file
  tmp_file=$(mktemp /tmp/tmp_file_XXXXXX.dat) || return 1
  is_valid_file
    
  if ! sort -t ':' -k 3 -n -r "$DATABASE" > "$tmp_file"; then
    echo "Error: Failed to sort database." >&2
    rm -f "$tmp_file"
    return
  fi
  
  mv "$tmp_file" "$DATABASE"
}

add_entry() {

  local name
  local city
  local balance
  local phone
  local -i error_counter
  local retry
  
  while true; do
    error_counter=0
    name=""
    city=""
    balance=""
    phone=""
    retry="n"
    
    echo
    name=$(ask_data "name")  
    city=$(ask_data "city")  
    balance=$(ask_data "balance")  
    phone=$(ask_data "phone")
    echo
    
    error_counter=$(handle_errors "$name" "$city" "$balance" "$phone")   

    if (( error_counter <= 0 )); then
      save_entry "$name" "$city" "$balance" "$phone"
      return
    else      
      echo
      read -r -p "   Do you want to try again? (y/n) " retry
      if [[ "$retry" =~ [nN] ]]; then
        return
      fi
    fi
  done
}

handle_errors() {

  local name="$1"
  local city="$2"
  local balance="$3"
  local phone="$4"
  local -i error_counter=0
  
    if ! validate_name "$name"; then
      ((error_counter+=1))
    fi  
    if ! validate_city "$city"; then
      ((error_counter+=1))
    fi
    if ! validate_balance "$balance"; then
      ((error_counter+=1))
    fi
    if ! validate_phone "$phone"; then
      ((error_counter+=1))
    fi
    
    echo "$error_counter"
}

validate_name() {

  local name="${1:-}"
  local name_max_size=18
  
  if ! check_not_empty_value "name" "$name"; then
    return 1
  fi
  
  if ! check_input_size "name" "$name" "$name_max_size"; then
    return 1
  fi  
  
  if ! check_unique_name "$name"; then
    return 1
  fi
}

validate_city() {

  local city="${1:-}"
  local city_max_size=15
  
  if ! check_not_empty_value "city" "$city"; then
    return 1
  fi
  
  if ! check_input_size "city" "$city" "$city_max_size"; then
    return 1
  fi  
}

validate_balance() {

  local balance="${1:-}"
  local balance_max_size=12
  
  if ! check_not_empty_value "balance" "$balance"; then
    return 1
  fi
  
  if ! check_input_size "balance" "$balance" "$balance_max_size"; then
    return 1
  fi  
  
  if ! check_numeric_value "balance" "$balance"; then
    return 1
  fi
}

validate_phone() {

  local phone="${1:-}"
  local phone_max_size=9
  
  if ! check_not_empty_value "phone" "$phone"; then
    return 1
  fi
  
  if ! check_input_size "phone" "$phone" "$phone_max_size"; then
    return 1
  fi
  
  if ! check_numeric_value "phone" "$phone"; then
    return 1
  fi
}

check_not_empty_value() {

  local key="${1:-}"
  local value="${2:-}"

  if [ -z "$value" ]; then
    echo -e "\tError: Parameter [$key] must not be empty" >&2
    return 1
  fi
  
  if [[ "$value" =~ ^[[:space:]]*$ ]]; then
    echo -e "\tError: Parameter [$key] must not contain only whitespace" >&2
    return 1
  fi
}

check_unique_name() {

  local param="${1:-}"  
  is_valid_file
  
  if cut -f 1 -d ':' "$DATABASE" | grep -qw "$param"; then
    echo -e "\tError: Field NAME must be unique" >&2
    return 1
  fi
}

check_numeric_value() {

  local key="${1:-}"
  local value="${2:-}"
  
  if ! [[ "${value}" =~ ^[0-9]+$ ]]; then
    echo -e "\tError: Parameter [$key] must contain only digits" >&2
    return 1
  fi
}

check_input_size() {

  local key="${1:-}"
  local value="${2:-}"
  local size="${3:-33}"
  
  if (( "${#value}" > size )); then
    echo -e "\tError: Parameter [$key] must have length less or equal than [$size]" >&2
    return 1
  fi
}

save_entry() {

  local name="$1"
  local city="$2"
  local balance="$3"
  local phone="$4"

  is_valid_file
  if printf "%s:%s:%s:%s\n" "$name" "$city" "$balance" "$phone" >> "$DATABASE"; then
    echo -e "\n\tInfo: Success saving entry" >&2
  else
    echo -e "\n\tError: Fail saving entry" >&2
  fi
}

delete_entry() {

  local name_to_delete=""
  name_to_delete=$(ask_data "name")
  
  is_valid_file      
  if ! cut -f 1 -d ':' "$DATABASE" | grep -qw "$name_to_delete"; then
    echo -e "\n\tInfo: There are no coincidences. Nothing to delete." >&2
    return
  else      
    echo
    local sure=""
    read -r -p "   Are you sure you want to delete? (y/n) " sure    
    if [[ "$sure" =~ [yY] ]]; then 
      local tmp_file
      tmp_file=$(mktemp /tmp/tmp_file_XXXXXX.dat) || return 1  
      is_valid_file
      while IFS=':' read -r name city balance phone; do
      if [[ "$name" != "$name_to_delete" ]]; then
        printf "%s:%s:%s:%s\n" "$name" "$city" "$balance" "$phone" >> "$tmp_file"
      fi
      done < "$DATABASE"  

      mv "$tmp_file" "$DATABASE" && rm -f "$tmp_file"
    fi
  fi
}

menu() {

  while true; do
  
    print_main_header
    print_menu_options
  
    local option=""
    option=$(ask_data "option")
    
    case "$option" in
      h)
        print_help        
        ;;
      q)
        bye
        exit 0
        ;;
      l)
        list_db        
        ;;
      on)
        order_by_name_asc    
        ;;
      os)
        order_by_balance_desc      
        ;;
      a)
        add_entry
        ;;
      b)
        delete_entry    
        ;;
      *)
        echo -e "\n\tError: Unknown option [$option]" >&2
        ;;    
    esac
    press_key_to_continue
  done
}

main() {

  check_args "$@"
  init_db "$@"
  menu
}

main "$@"

