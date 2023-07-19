#!/bin/bash

# Nome VM o ID
VM_NAME="metasploitable3-win2k8"

# Elenca tutte le regole di port forwarding per la VM specificata
RULES=$(vboxmanage showvminfo "$VM_NAME" --machinereadable | grep "Forwarding")

# Estrai i numeri delle regole e rimuovile una per una
for RULE in $RULES; do
    RULE_N=$(echo "$RULE" | grep -oP 'Rule(TCP|UDP)[0-9]+')
    vboxmanage modifyvm "$VM_NAME" --natpf1 delete $RULE_N
done
