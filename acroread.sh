#!/bin/bash
source config.cfg
sshpass -p$pass ssh -p 80 -X $user@$ip acroread &
