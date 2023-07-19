#!/bin/bash

# nome VM o ID
VM_NAME="metasploitable3-win2k8"

# starting/ending port
#INIT_PORT=1
#ENDING_PORT=10000

# indirizzo ip della macchina
HOST_IP=$(hostname -I | awk '{print $1}')

# Percorso del file contenente i numeri di porta
PORT_FILE="enum_ports.txt"

# Leggi il file delle porte e crea le regole di port forwarding con eccezione della porta 22 mappata su 2222
while read -r PORT; do
    if [ "$PORT" != "22" ]; then
        vboxmanage modifyvm "$VM_NAME" --natpf1 "RuleTCP$PORT,tcp,$HOST_IP,$PORT,,$PORT"
        vboxmanage modifyvm "$VM_NAME" --natpf1 "RuleUDP$PORT,udp,$HOST_IP,$PORT,,$PORT"
    else
        vboxmanage modifyvm "$VM_NAME" --natpf1 "RuleTCP$PORT,tcp,$HOST_IP,2222,,$PORT"
    fi
done < "$PORT_FILE"

vboxmanage showvminfo "$VM_NAME" --machinereadable | grep "Forwarding"

# #[--natpf<1-N> [<rulename>],tcp|udp,[<hostip>],<hostport>,[<guestip>],<guestport>]
# for ((INIT_PORT; INIT_PORT <= ENDING_PORT; INIT_PORT++)); do

#     if [ $INIT_PORT -ne 22 ]; then
#         vboxmanage modifyvm "$VM_NAME" --natpf1 "Rule$INIT_PORT,tcp,$HOST_IP,$INIT_PORT,,$INIT_PORT"

#         vboxmanage modifyvm "$VM_NAME" --natpf1 "Rule$INIT_PORT,udp,$HOST_IP,$INIT_PORT,,$INIT_PORT"
#     else 
#         vboxmanage modifyvm "$VM_NAME" --natpf1 "Rule$INIT_PORT,tcp,$HOST_IP,2222,,$INIT_PORT"
#     fi
# done
