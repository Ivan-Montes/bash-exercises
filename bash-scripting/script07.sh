#!/bin/bash
set -euo pipefail
#set -x


check_args() {

  if (( $# != 2 )); then
    echo -e "\tError: we need 2 args" >&2
    exit 1
  fi
}

validate_args() {

  local file="$1"
  local dir="$2"
  
  validate_file "$file"
  validate_dir "$dir"
}

validate_file() {

  local file="$1"
  
  if ! [[ -f "$file" ]]; then
    echo -e "\tError: file invalid => $file" >&2
    exit 1
  fi
  
  if ! [[ -r "$file" ]]; then
    echo -e "\tError: READ permission is required => $file" >&2
    exit 1
  fi
}

validate_dir() {

  local dir="$1"
  
  if ! [[ -d "$dir" ]]; then
    echo -e "\tError: Route must be a valid directory => $dir" >&2
    exit 1
  fi
  
  if ! [[ -r "$dir" ]]; then
    echo -e "\tError: READ permission is required => $dir" >&2
    exit 1
  fi
  
  if ! [[ -w "$dir" ]]; then
    echo -e "\tError: WRITE permission is required => $dir" >&2
    exit 1
  fi
  
  if ! [[ -x "$dir" ]]; then
    echo -e "\tError: EXECUTE permission is required => $dir" >&2
    exit 1
  fi
}

copy_file() {

  local file="$1"
  local dir="$2"
  
  if cp "$file" "$dir"; then
    echo -e "\tCopy successfully: $file => $dir"
  else
    die "Error on copy: $file => $dir"
  fi
}

die() {

  echo -e "\t$*" >&2
  exit 1
}

mod_permissions() {

  local file="$1"
  local dir="$2"
  local route_with_file="$dir/$file"

  if chmod ug+x "$route_with_file"; then
    echo -e "\tPermissions added: $route_with_file (user/group executable)"
  else
    die "Failed to add permissions: $route_with_file"
  fi

  if chmod o-x "$route_with_file"; then
    echo -e "\tPermissions removed: $route_with_file (others no longer executable)"
  else
    die "Failed to remove permissions: $route_with_file"
  fi
}

main() {

  check_args "$@"
  validate_args "$@"
  copy_file "$@"
  mod_permissions "$@"
}

main "$@"
