#!/bin/bash

function select_interface() {
  echo -e "${blue}Interfaces disponibles:${end}"
  ifconfig | grep -E '^[a-zA-Z0-9]+' | awk -F: '{print " ➤", $1}'

  while true; do
    echo -ne "${yellow}[?] Elige una interfaz: ${end}" && read interface
    if ifconfig "$interface" &>/dev/null; then
      break
    else
      echo -e "${red}[!] Interfaz inválida. Intenta de nuevo.${end}"
    fi
  done
}

function get_attacker_ip() {
  ip=$(ifconfig "$interface" | grep 'inet ' | awk '{print $2}')
  export ip
  echo -e "${green}[✓] IP atacante: $ip${end}"
}


function ask_yes_no() {
  while true; do
    echo -ne "${yellow}[?] ¿Deseas escanear la red para encontrar víctimas? (si/no): ${end}" && read response
    case "$response" in
      [Ss][Ii]|[Yy][Ee][Ss]) return 0 ;;
      [Nn][Oo]) return 1 ;;
      *) echo -e "${red}[!] Respuesta inválida. Escribe 'sí' o 'no'.${end}" ;;
    esac
  done
}

function get_victim_ip() {
  if ask_yes_no; then
    subnet=$(echo "$ip" | cut -d. -f1-3)
	sudo arp-scan -I "$interface" "$subnet.0/24" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' > resultados_escaneo/arp/red.txt
  if [[ "$INCLUDE_GATEWAY" == true ]]; then
	   mapfile -t discovered_ips < resultados_escaneo/arp/red.txt
  else
	   mapfile -t discovered_ips < <(grep -Ev '\.1$|\.2$|\.254$' resultados_escaneo/arp/red.txt)
  fi


    if [[ ${#discovered_ips[@]} -eq 0 ]]; then
      echo -e "${red}[!] No se detectaron IPs activas en la red.${end}"
      exit 1
    fi

    echo -e "\n${blue}[✓] IPs detectadas por arp-scan:${end}"
    for ip in "${discovered_ips[@]}"; do
      echo -e " ➤ $ip"
    done

    while true; do
      echo -e "\n${yellow}[?] ¿Quieres escanear TODAS las IPs detectadas o UNA en específico?${end}"
      echo -e "${gray}1) Todas${end}"
      echo -e "${gray}2) Una en específico${end}"
      echo -ne "${yellow}[+] Elige opción (1/2): ${end}" && read option

      case "$option" in
        1)
          ip_targets=("${discovered_ips[@]}")
          break
          ;;
        2)
          while true; do
            echo -ne "${yellow}[+] Escribe la IP a escanear: ${end}" && read single_ip
            if [[ ( " ${discovered_ips[*]} " =~ " ${single_ip} " || "$single_ip" == "127.0.0.1" ) && "$single_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
              ip_targets=("$single_ip")
              break
            else
              echo -e "${red}[!] IP inválida. Debe ser una IP detectada y con formato correcto.${end}"
            fi
          done
          break
          ;;
        *)
          echo -e "${red}[!] Opción inválida. Solo 1 o 2.${end}"
          ;;
      esac
    done
  else
    while true; do
      echo -ne "${yellow}[+] Introduce manualmente la IP víctima (formato X.X.X.X): ${end}" && read manual_ip
      if [[ "$manual_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        ip_targets=("$manual_ip")
        break
      else
        echo -e "${red}[!] IP inválida. Asegúrate del formato correcto. Ej: 192.168.1.35${end}"
      fi
    done
  fi
}
