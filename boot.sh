#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Wait for Internet access"
while ! curl --connect-timeout 3 "http://www.google.com" &> /dev/null
    do continue
done
apt-get update -y
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker pull bkimminich/juice-shop
docker run -d -p 3000:3000 bkimminich/juice-shop

