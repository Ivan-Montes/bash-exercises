#!/bin/bash
set -euo pipefail
#set -x

show_date() {

  read -r year month day hour minute <<< "$(date '+%Y %b %d %H %M')"

  echo -e "\tIt's $hour hours and $minute minutes on the $day of $month, $year"

}

main() {

  show_date

}

main "${@}"
