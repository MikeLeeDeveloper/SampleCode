#!/bin/bash

# Use 65 when using hotspot from computer
# Use 64 when using computer as wifi repeater
hHopLimit=65

# Default MacOS/Linux TTL
dHopLimit=64

# Get current TTL value
currentTTL=$(sysctl net.inet.ip.ttl)
currentTTL=${currentTTL##*:}

# Check if current TTL is default value
if [ $currentTTL == $dHopLimit ]
then
    # Update TTL to Hotspot
    sudo sysctl net.inet.ip.ttl=$hHopLimit
    sudo sysctl net.inet6.ip6.hlim=$hHopLimit
    echo "System has been set to Mobile Hotspot Mode"
else
    # Update TTL to Default
    sudo sysctl net.inet.ip.ttl=$dHopLimit
    sudo sysctl net.inet6.ip6.hlim=$dHopLimit
    echo "System has been set to default Default"
fi