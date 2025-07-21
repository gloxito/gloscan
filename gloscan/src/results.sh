#!/bin/bash

function show_results() {
  echo -e "\n${purple}========= RESULTADOS =========${end}"

  if [[ ${#ip_targets[@]} -eq 1 ]]; then
    echo -e "${blue}IP Víctima: ${ip_targets[0]}${end}"
  elif [[ ${#ip_targets[@]} -gt 1 ]]; then
    echo -e "${blue}IPs Víctimas: ${ip_targets[*]// /, }${end}"
  else
    echo -e "${red}[!] No se especificaron IPs víctimas.${end}"
    return
  fi

  for ip_target in "${ip_targets[@]}"; do
    scan_dir="resultados_escaneo/nmap/$ip_target"
    echo -e "\n${yellow}[•] Resultados para: $ip_target${end}"

    if [[ -f "$scan_dir/puertos_filtrados.txt" ]]; then
      cat "$scan_dir/puertos_filtrados.txt" | column -t
    else
      echo -e "${red}[!] No se encontraron resultados guardados para esta IP.${end}"
    fi
  done
}
