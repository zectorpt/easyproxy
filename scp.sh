#!/bin/bash
echo "Origem: (exemplo /tmp/file.rpm)"
read remote
echo "Destino: (exemplo /tmp/)"
read local
echo "We need the root Password"
scp -P 80 root@IP:$remote $local
