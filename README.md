##Welcome to Easy Proxy Hatfield!
###How bypass your company security? Your country deny some sites/IP's?

If you already have a VPS, you can use it. If not, you can buy one for less than 2eur / month <br><br>

Pre requirements:<br>
VPS with Centos 7<br>
1GB RAM (minimum)<br>

Remote server:<br>
ssh to vps as root<br>
yum install git -y<br>
git clone https://github.com/zectorpt/easyproxy.git<br>
cd easyproxy/server/<br>
./SETUP.sh<br>

In your local computer (Linux):<br>
Insert the IP of the remote server in config.cfg<br>
./connect.sh

In your local computer (Windows):<br>
Insert IP of the remote server in connect.bat<br>
putty.exe -P 80 -X root@IP -pw PASS<br>

FAQ:<br>
Q: My company block the port 80, how can I be free?<br>
A: Easy! Change the file server/SETUP.sh on line 61. Change port 80 to the port that you want. Remember that port should be open in your company. Usually port 80 is open, but... if not, chose another.<br>

Q: How this works? Software is installed in my company LAPTOP?<br>
A: No, nothing is installed in your Laptop. Everything is in the external VPS. There are no cookies or way to trace. All software is running on the VPS. After close Easy Proxy Hatfield your PC is clean!<br>

Q: Where can I buy a VPS?<br>
A: I don't have any business related with VPS's, but there are some VPS's too cheap. For this propose I use www.firstheberg.com<br>

Q: I don't Like Centos/Redhat. What can I do?<br>
A: If, for any reason you need to use any other distro, edit SETUP.sh and change the YUM by APTITUDE... for example. There are same changes that you should do in the SSH configuration.<br>

Q: It is free? How much it will cost me?<br>
A: It's not free. You should send me an email saying Thank you!<br>

Q: I really need help, who can help me?<br>
A: Send me an email.<br>

Q: I downloaded a file with Chrome, how can I get it to my laptop?<br>
A: In your browser do: http://IP:443<br>

Q: Why do you choose 443 do apache?<br>
A: Because in most Companies and Countries the 80 and 443 port all allways open (http && https)<br>

Q: This is a closed project? It's possible improve?<br>
A: YES! The menu and the applications installed can be much more! Try more applications and add them to the menu!<br>

-----------------------------------------------------------------------------

If you like it, star my repo and don't delete my email from source code<br />
josemedeirosdealmeida@gmail.com <br />
josemedeirosdealmeida.com

