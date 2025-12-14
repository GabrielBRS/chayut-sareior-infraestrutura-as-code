#!/bin/bash
# Script para adicionar um servidor Dell ao MAAS via IPMI (iDRAC)
# Uso: ./add_dell_node.sh <nome_servidor> <mac_address> <ip_idrac> <senha_idrac>

PROFILE="ortzion-admin"
HOSTNAME=$1
MAC_ADDRESS=$2
POWER_ADDRESS=$3 # IP da iDRAC
POWER_PASS=$4

echo "--- Registrando Dell PowerEdge: $HOSTNAME ---"

# 1. Cria a máquina no inventário do MAAS
ID=$(maas $PROFILE machines create \
    architecture=amd64 \
    mac_addresses=$MAC_ADDRESS \
    hostname=$HOSTNAME \
    power_type=ipmi \
    power_parameters_power_address=$POWER_ADDRESS \
    power_parameters_power_user=root \
    power_parameters_power_pass=$POWER_PASS \
    | jq -r '.system_id')

echo "--- Máquina Criada com ID: $ID. Iniciando Commissioning... ---"

# 2. Inicia o comissionamento (MAAS liga a iDRAC, testa hardware e desliga)
maas $PROFILE machine commission $ID