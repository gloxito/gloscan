#!/bin/bash

function run_scan() {
  for ip_target in "${ip_targets[@]}"; do
    scan_dir="resultados_escaneo/nmap/$ip_target"
    mkdir -p "$scan_dir"

    echo -e "${blue}[•] Escaneando $ip_target (guardando en $scan_dir)...${end}"

    # Guardar resultados sin mostrar por pantalla
    sudo nmap -A -T4 --min-rate 4000 "$ip_target" -oN "$scan_dir/resumen.txt" -oX "$scan_dir/resumen.xml" &>/dev/null

    # Extraer info legible
    awk '/open/{print $1, $2, $3, $4, $5}' "$scan_dir/resumen.txt" > "$scan_dir/puertos_filtrados.txt"
  done
}
