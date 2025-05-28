#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
    echo -e "\n${redColour}[!] Saliendo...${endColour}"
    tput cnorm
    exit 1
}

trap ctrl_c INT


function tools_checker() {
    tput civis
    echo -e "${blueColour}[*] Verificando herramientas necesarias...${endColour}"


    # Array to save nmap and arp-scan in case of missing

    tools_needed=()

    if ! command -v nmap &>/dev/null; then
        tools_needed+=("nmap")
    fi


    if ! command -v arp-scan &>/dev/null; then
        tools_needed+=("arp-scan")
    fi


    if [ ${#missing_tools[@]} -eq 0 ]; then
        echo -e "${greenColour}[✓] Todas las herramientas están instaladas.${endColour}"
    else
        echo -e "${yellowColour}[!] Faltan herramientas: ${missing_tools[*]}${endColour}"
        echo -e "${blueColour}[*] Actualizando el sistema...${endColour}"
        if ! sudo apt update &>/dev/null; then
            echo -e "${redColour}[✗] No se pudo actualizar el sistema. Abortando.${endColour}"
            exit 1
        else
            echo -e "${blueColour}[*] Intentando instalar herramientas con apt...${endColour}"                     
            for tool in "${missing_tools[@]}"; do
                if  ! sudo apt install -y "$tool" &>/dev/null; then
                    echo -e "${redColour}[✗] Error al instalar ${tool}. Abortando.${endColour}"
                    exit 1
                else 
                
                    echo -e "${greenColour}[✓] ${tool} instalado correctamente.${endColour}"
                fi
            done
            echo -e "${greenColour}[✓] Todas las herramientas faltantes fueron instaladas.${endColour}"
            
        fi
    fi

    tput cnorm
}


function position() {
  current_dir="$(basename "$PWD")"

  # Si ya estás en glocker, solo verifica subdirectorios
  if [ "$current_dir" == "gloscan" ]; then
    mkdir -p resultados_escaneo/nmap
    mkdir -p resultados_escaneo/arp-scan
    chmod -R 755 .
  else
    mkdir -p gloscan
    mkdir -p gloscan/resultados_escaneo/nmap
    mkdir -p gloscan/resultados_escaneo/arp-scan
    chmod -R 755 glocker
    cd gloscan || exit 1
  fi
}



function banner_block(){
  echo -e "${purpleColour}"
  echo -e " ██████╗ ██╗      ██████╗ ███████╗ ██████╗ █████╗ ███╗   ██╗"
  echo -e "██╔════╝ ██║     ██╔═══██╗██╔════╝██╔════╝██╔══██╗████╗  ██║"
  echo -e "██║  ███╗██║     ██║   ██║███████╗██║     ███████║██╔██╗ ██║"
  echo -e "██║   ██║██║     ██║   ██║╚════██║██║     ██╔══██║██║╚██╗██║"
  echo -e "╚██████╔╝███████╗╚██████╔╝███████║╚██████╗██║  ██║██║ ╚████║"
  echo -e " ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝"

  echo -e "                             ${yellowColour}by Glox${endColour}"
  echo -e "${endColour}"
}

function welcome(){
  clear
  banner_block
  echo -e "${turquoiseColour}════════════════════════════════════════════════════════════════${endColour}"
  echo -e "${yellowColour}            🧠 Automatización de Reconocimiento CTF             ${endColour}"
  echo -e "${turquoiseColour}════════════════════════════════════════════════════════════════${endColour}"
  echo -e "${grayColour}   Esta herramienta automatiza el reconocimiento de máquinas    ${endColour}"
  echo -e "${grayColour}      usando Netdiscover / arp-scan y escaneo con Nmap.         ${endColour}"
  echo -e "${grayColour}     Los dominios detectados se agregan automáticamente a       ${endColour}"
  echo -e "${grayColour}                      tu archivo /etc/hosts.                   ${endColour}"
  echo -e "${turquoiseColour}════════════════════════════════════════════════════════════════${endColour}"
}

function interface_guesser(){
  echo -e "\n${blueColour}═══════════════════════════════════════════════${endColour}"
  echo -e "${blueColour}▶ Interfaces de red activas en tu sistema:${endColour}"
  echo -e "${blueColour}═══════════════════════════════════════════════${endColour}"
  ip -br link | awk '$2 == "UP" && $1 != "lo" {print " ➤", $1}'
  echo ""
  echo -ne "\n${yellowColour}[?]${endColour} ${grayColour}¿En qué interfaz estás operando? ➤ ${endColour}" && read interface

  interface_checker="$(ifconfig | grep "$interface")"
  if [ "$interface_checker" ]; then
      echo -e "\n${blueColour}[✓]${endColour} ${grayColour}IP localizada desde la interfaz${endColour} ${blueColour}$interface${endColour}"
      tput civis
      sleep 1
      clear
      tput cnorm
  else
      echo -e "\n${redColour}═══════════════════════════════════════════════${endColour}"
      echo -e "${redColour}[!] Interfaz inválida. Estas son las disponibles:${endColour}"
      echo -e "${redColour}═══════════════════════════════════════════════${endColour}"
      ip -br link | awk '$2 == "UP" && $1 != "lo" {print " ➤", $1}'
      interface_guesser
  fi
}

function get_ip_attack() {
  ip="$(ifconfig $interface | grep 'inet ' | awk '{print $2}')"
  if [ "$ip" ]; then
      echo -e "\n${greenColour}╔═══════════════════════════════════════════════════════════╗${endColour}"
      echo -e "${greenColour}║${endColour} ${grayColour}IP de atacante detectada en interfaz ${purpleColour}$interface${endColour}${grayColour}:${endColour} ${blueColour}$ip${endColour} ${greenColour}║${endColour}"
      echo -e "${greenColour}╚═══════════════════════════════════════════════════════════╝${endColour}"
  else
      echo -e "\n${redColour}[!]${endColour} ${grayColour}No se pudo obtener IP desde la interfaz especificada.${endColour}"
  fi
}

function get_ip_victim(){
    echo -ne "\n${yellowColour}[?]${endColour} ${grayColour}¿Ya sabes la IP de la víctima?${endColour} ${blueColour}(escribe${endColour} ${purpleColour}'no'${endColour} ${blueColour}para escanear)${endColour} ${grayColour}➤ ${endColour}" && read victim_ip
    victim_ip=$(echo "$victim_ip" | tr '[:upper:]' '[:lower:]' | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ü/u/g; s/ñ/n/g' | tr -d '[:space:]')
    tput civis
    sleep 1
    if [ "$victim_ip" == "no" ]; then
        subnet="$(echo $ip | cut -d '.' -f1-3)"
	cd resultados_escaneo/arp-scan
        sudo arp-scan -I $interface $subnet.0/24 | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print $1}' > resultados_escaneo_red.txt
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dispositivos detectados:${endColour}\n${blueColour}"
        cat resultados_escaneo_red.txt | column
        echo -e "${endColour}"

    elif [[ "$victim_ip" == "si" || "$victim_ip" == "sí" ]]; then
	tput cnorm
        while true; do
            echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}Introduce la IP ➤ ${endColour}" && read custom_ip
            if [[ "$custom_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                echo -e "${greenColour}[✓]${endColour} ${grayColour}Dirección IP válida:${endColour} ${blueColour}$custom_ip${endColour}"
		clear
                break
            else
                echo -e "${redColour}[!]${endColour} ${grayColour}Formato inválido. Ejemplo válido: 192.168.1.100${endColour}"
            fi
        done
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Respuesta inválida.${endColour}"
	sleep 1

	echo -e "\n${greenColour}╔═══════════════════════════════════════════════════════════╗${endColour}"
      echo -e "${greenColour}║${endColour} ${grayColour}IP de atacante detectada en interfaz ${purpleColour}$interface${endColour}${grayColour}:${endColour} ${blueColour}$ip${endColour} ${greenColour}║${endColour}"
      echo -e "${greenColour}╚═══════════════════════════════════════════════════════════╝${endColour}"
        get_ip_victim
    fi
}

function devices_ip_scan(){
    sleep 2
    clear
    tput civis
    ip_target=${custom_ip:-$(grep -Ev "^$subnet\.(1|2|254)$" resultados_escaneo_red.txt)}

    cd ../nmap
    echo -e "\n${yellowColour}📡 Escaneando puertos y servicios de $ip_target ...${endColour}"
    filter_domain_hosts="$(sudo nmap -p- --open -sSCV -Pn -n -T5 --min-rate 5000 $ip_target -oG resultados_nmap.txt -oX resultados_nmap.xml | grep "http-title: " | awk '{print $7}' | sed 's|http://||')"
    cd ../../
    if [ "$filter_domain_hosts" ]; then
        echo -e "\n${greenColour}[✓]${endColour} ${grayColour}Dominio detectado:${endColour} ${blueColour}$filter_domain_hosts${endColour}"
        #echo "$ip_target $filter_domain_hosts" >> /etc/hosts
	echo "$ip_target $filter_domain_hosts" | sudo tee -a /etc/hosts > /dev/null

    else
        echo -e "\n${yellowColour}[•]${endColour} ${grayColour}No se detectaron dominios web.${endColour}"
    fi
}

function final_results(){
  echo -e "\n${purpleColour}"
  echo    "╔══════════════════════════════════════════════════════╗"
  echo    "║           R E S U L T A D O S   F I N A L E S        ║"
  echo    "╚══════════════════════════════════════════════════════╝"
  echo -e "${endColour}"
  echo -e "\n"
  echo -e "${yellowColour}[+]${endColour} ${grayColour}Interfaz e IP atacante:${endColour} ${blueColour}$interface${endColour} ${grayColour}|${endColour} ${blueColour}$ip${endColour} "
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}IP víctima:${endColour} ${blueColour}$ip_target${endColour}"
  cd resultados_escaneo/nmap
  final_ports_result="$(cat resultados_nmap.txt | grep "Ports: " | awk -F'Ports: ' '{print $2}' | tr ',' '\n' | awk -F'/' '{gsub(/^[ \t]+/, "", $1); if ($1 && $5) printf "%s - %s\n", $1, $5}' | column)"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Puertos: ${endColour}${blueColour}$final_ports_result${endColour}"
  if [ "$filter_domain_hosts" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dominio agregado a${endColour} ${purpleColour}/etc/hosts${endColour}${grayColour}:${endColour} ${blueColour}$filter_domain_hosts${endColour}"
  fi
  echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Todos los resultados han sido guardados en la carpeta ->${endColour} ${blueColour}glocker${endColour}"

  cd ../../
}

function main(){
    tools_checker
    position
    banner_block
    welcome
    interface_guesser
    get_ip_attack
    get_ip_victim
    devices_ip_scan
    final_results
    tput cnorm
}

main
