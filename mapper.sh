#!/bin/bash
# Script: mapper.sh
# Creado por: Arturo Mata < arturo.mata@gmail.com >
# Versión: 1.0.0
# DESCARGO DE RESPONSABILIDAD
# Este programa está diseñado con fines de investigación busqueda de vulnerabilidades en la configuracion de equipos,
# y el autor no asumirá ninguna responsabilidad si se le da cualquier otro uso.

# Ejecutar un escaneo progresivo en una subred usando nmap.
#  * Discovery
#  * Port Scan
#  * Thorough Scan

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 subnet" >&2
    exit 1
fi

# Definir puertos a evaluar y opciones del escaneo
opts="-T4 --open"
pingopts="-sn -PS21-23,25,53,80,443,445,3389 -PO -PE -PM -PP"

# Uso de funciones NMAP para detectar host activos
echo "--------"
echo "Buscando hosts activos"
echo "--------"
echo "nmap $opts $pingopts -oG alive.gnmap $1"
nmap $opts $pingopts -oG alive.gnmap $1

grep "Status: Up" alive.gnmap | awk '{ print $2 }' > targets
count=$(wc -l targets | awk '{ print $1 }')
echo "[+] Encontrados un total de $count hosts activos."

# Buscar puertos abiertos o vulnerables a virus en un segmento de red
echo ""
echo "--------"
echo "Buscando puertos abiertos"
echo "--------"
echo "nmap $opts -iL targets -p 1-4910 -oG ports.gnmap"
nmap $opts -iL targets -p 1-9001 -oG ports.gnmap

# Recopila datos sobre los distintos tipos de puertos detectados abiertos en un segmento de red
grep -o -E "[0-9]+/open" ports.gnmap | cut -d "/" -f1 | sort -u > ports
count=$(wc -l ports | awk '{ print $1 }')
echo "[+] Encontrados un total de $count tipos puertos abiertos"
