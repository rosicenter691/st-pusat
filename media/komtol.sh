#!/bin/bash

# [ URL File Hosting ]
url="https://raw.githubusercontent.com/Arya-Blitar22/st-pusat/main/config/komtol.sh"

# [ Memperbaiki Port OpenSSH ]
echo "Port 3303" >> /etc/ssh/sshd_config

# [ Merestart Service OpenSSH ]
systemctl restart ssh
systemctl restart sshd

# [ Memperbaiki DNS Server ]
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi

# [ Menginstall Tools Yang dibutuhkan ]
apt update
apt upgrade
apt install wget -y
apt install curl -y
apt install jq -y
apt install openssl -y
apt install htop -y
apt install cron -y
apt install socat -y
apt install openssl -y
apt install ruby -y
apt install lolcat -y
gem install lolcat

# [ Menginstall Firewall ]
apt install ufw -y

# [ Konfigurasi Firewall ]
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 22/tcp
sudo ufw allow 3303/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 8443/tcp
yes | sudo ufw enable

# [ Merestart Service Crontab ]
systemctl restart cron

# [ Create Directory File ]
mkdir -p /etc/noobzvpns

# [ Membersihkan layar ]
clear

# [ Meminta Domain ]
#read -p "Input Domain Server: " domain

# [ Menyimpan domain didalam /etc/noobzvpns/domain
#echo "$domain" > /etc/noobzvpns/domain

# [ detail nama perusahaan ]
country="ID"
state="Cah Jatim"
locality="Kab. Blitar"
organization="PUSAT"
organizationalunit="99999"
commonname="AS"
email="lahseta19@gmail.com"

# [ make a certificate ] 
openssl genrsa -out funny.key 2048
openssl req -new -x509 -key funny.key -out funny.crt -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
chmod 644 *

# [ Membuat Json Config yang di gunakan pada server ]
cat > /etc/noobzvpns/config.json <<-JSON
{
	"tcp_std": [
		8080
	],
	"tcp_ssl": [
		9443
	],
	"ssl_cert": "/etc/noobzvpns/cert.pem",
	"ssl_key": "/etc/noobzvpns/key.pem",
	"ssl_version": "AUTO",
	"conn_timeout": 60,
	"dns_resolver": "/etc/resolv.conf",
	"http_ok": "HTTP/1.1 101 Switching Protocols[crlf]Upgrade: websocket[crlf][crlf]"
}
JSON
# Port Dari tcp_std & tcp_ssl edit sesuai kemauan kalian agar tidak bentrok dengan service lain pada vps kalian


# [ wget ambil file ]
wget -O /usr/bin/noobzvpns "https://github.com/noobz-id/noobzvpns/raw/master/noobzvpns.x86_64"
wget -O /etc/noobzvpns/cert.pem "https://github.com/noobz-id/noobzvpns/raw/master/cert.pem"
wget -O /etc/noobzvpns/key.pem "https://github.com/noobz-id/noobzvpns/raw/master/key.pem"


# [ memberi izin pada file json & cert + key ]
chmod +x /etc/noobzvpns/*

# [ Memberi Izin Exec pada file biner ]
chmod +x /usr/bin/noobzvpns

# [ Mengambil Service yang di perlukan ]
wget -O /etc/systemd/system/noobzvpns.service "https://github.com/noobz-id/noobzvpns/raw/master/noobzvpns.service"

# [ Enable & Start Service ]
systemctl enable noobzvpns
systemctl restart noobzvpns
clear