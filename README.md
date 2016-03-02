## Easy Proxy. How bypass your company security!
###Welcome to Easy Proxy Hatfield

If you already have a VPS, you can use it. If not, you can buy one for less than 2eur / month <br><br>

Pre requirements:
Centos 7
Min 1GB RAM

Remote server:<br>
ssh to vps as root<br>
yum install git -y
git clone https://github.com/zectorpt/easyproxy.git<br>
cd easyproxy/server/<br>
./SETUP.sh<br>

In your local computer (Linux):<br>
Insert the IP of the remote server in config.cfg<br>
./connect.sh

In your local computer (Windows):<br>
Insert IP of the remote server in connect.bat<br>
putty.exe -P 80 -X root@IP -pw PASS

FAQ:
Q: My company block the port 80, how can I be free?
A: Easy! Change the file server/SETUP.sh on line 61. Change port 80 to the port that you want. Remember that port should be open in your company. Usually port 80 is open, but... if not, chose another.

Q: How this works? Software is installed in my company LAPTOP?
A: No, nothing is installed in your Laptop. Everything is in the external VPS. There are no cookies or way to trace. All software are running in the VPS. After close Easy Proxy Hatfield your PC is clean!

Q: Where can I buy a VPS?
A: I dont have any business related with VPS's, but there are some VPS's in the market extremely cheapests. For this propose I use www.firstheberg.com



-----------------------------------------------------------------------------

If you like it, star my repo and don't delete my email from source code<br />
josemedeirosdealmeida@gmail.com <br />
josemedeirosdealmeida.com

