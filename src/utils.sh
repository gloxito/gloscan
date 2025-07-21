#!/bin/bash

# === Colores ===
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

# === Salida limpia ===
function ctrl_c() {
  echo -e "\n${red}[!] Saliendo...${end}"
  tput cnorm
  exit 1
}

# === Logger ===
function log() {
  echo -e "${gray}[$(date +%H:%M:%S)]${end} $1"
}
