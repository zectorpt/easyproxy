#!/bin/bash
source config.cfg
echo "Origem: (exemplo /home/trtcode/file.pdf)"
read remote
echo "Destino: (exemplo /tmp/)"
read local
echo "We need the root Password"
scp -P 80 $user@$ip:$remote $local
