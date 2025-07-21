#!/bin/bash

function show_banner() {
  clear
  echo -e "${purple}"
  echo -e " ██████╗ ██╗      ██████╗ ███████╗ ██████╗ █████╗ ███╗   ██╗"
  echo -e "██╔════╝ ██║     ██╔═══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║"
  echo -e "██║  ███╗██║     ██║   ██║███████╗██║     ███████║██╔██╗ ██║"
  echo -e "██║   ██║██║     ██║   ██║╚════██║██║     ██╔══██║██║╚██╗██║"
  echo -e "╚██████╔╝███████╗╚██████╔╝███████║╚██████╗██║  ██║██║ ╚████║"
  echo -e " ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝"
  echo -e "                             ${yellow}by Glox${end}\n"
}

function show_welcome() {
  echo -e "${turquoise}════════════════════════════════════════════════════════════════${end}"
  echo -e "${yellow}            🧠 Automatización de Reconocimiento CTF             ${end}"
  echo -e "${turquoise}════════════════════════════════════════════════════════════════${end}"
  echo -e "${gray}   Esta herramienta automatiza el reconocimiento de máquinas    ${end}"
  echo -e "${gray}      usando arp-scan y escaneo con Nmap.                      ${end}"
  echo -e "${gray}     Los dominios detectados se agregan automáticamente a       ${end}"
  echo -e "${gray}                      tu archivo /etc/hosts.                   ${end}"
  echo -e "${turquoise}════════════════════════════════════════════════════════════════${end}"
}
