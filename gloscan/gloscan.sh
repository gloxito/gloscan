#!/bin/bash

# === Cargar módulos ===
source src/utils.sh
source src/banner.sh
source src/tools.sh
source src/network.sh
source src/scanner.sh
source src/results.sh

# === Flag para incluir .1, .2, .254 ===
INCLUDE_GATEWAY=false
for arg in "$@"; do
  if [[ "$arg" == "--include-gateway" ]]; then
    INCLUDE_GATEWAY=true
  fi
done

# === Control-C ===
trap ctrl_c INT

function main() {
  tools_checker
  setup_workspace
  show_banner
  show_welcome
  select_interface
  get_attacker_ip
  get_victim_ip
  run_scan
  show_results
  tput cnorm
}

main
