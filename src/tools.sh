#!/bin/bash

function tools_checker() {
  tput civis
  echo -e "${blue}[*] Verificando herramientas necesarias...${end}"
  tools_needed=(nmap arp-scan)
  missing=()

  for tool in "${tools_needed[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      missing+=("$tool")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    echo -e "${green}[✓] Todas las herramientas están instaladas.${end}"
  else
    echo -e "${yellow}[!] Faltan herramientas: ${missing[*]}${end}"
    sudo apt update -y &>/dev/null
    for pkg in "${missing[@]}"; do
      sudo apt install -y "$pkg" &>/dev/null || {
        echo -e "${red}[✗] No se pudo instalar $pkg. Abortando.${end}"; exit 1;
      }
      echo -e "${green}[✓] $pkg instalado.${end}"
    done
  fi
  tput cnorm
}

function setup_workspace() {
  mkdir -p resultados_escaneo/{nmap,arp}
  mkdir -p logs
  chmod -R 755 .
}
