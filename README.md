# Easy Proxy. How bypass your company security!

If you already have a VPS, you can use it. If not, you can buy one for less than 2eur / month <br><br>

On remote server (VPS):<br>
1 - Disable apache<br>
2 - Disable iptables<br>
3 - Configure sshd to port 80 (I believe that your company allow port 80)<br><br>

On local machine:<br>
1 - Use my scripts to call X server and use all aplications<br><br>

Pre requirements:<br><br>
sshpass<br>

#How to do easily with auto configure

Remote server:<br>
ssh to vps as root<br>
git clone https://github.com/zectorpt/easyproxy.git<br>
./SETUP.sh<br>
