#!/bin/bash

if [ -z "$JENKINS_HOST" ]; then
	echo "Enter your domain name:"
	read JENKINS_HOST
	export JENKINS_HOST
fi

if [ -z "$USER_EMAIL" ]; then
	echo "Enter your email for letsencrypt:"
	read USER_EMAIL
	export USER_EMAIL
fi

docker-compose -f initial-compose.yml up -d

docker run -it --rm \
-v /docker-volumes/etc/letsencrypt:/etc/letsencrypt \
-v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
-v /docker-volumes/data/letsencrypt:/usr/share/nginx/html \
-v "/docker-volumes/var/log/letsencrypt:/var/log/letsencrypt" \
certbot/certbot \
certonly --webroot \
--email $USER_EMAIL --agree-tos --no-eff-email \
--webroot-path=/data/letsencrypt \
-d $JENKINS_HOST

docker-compose -f initial-compose.yml down

export DOCKER_COMPOSE=$(which docker-compose)
envsubst < jenkins.service.template > /etc/systemd/system/jenkins.service
systemctl enable jenkins
systemctl start
(crontab -l 2>/dev/null; echo '0 23 * * * docker run --rm -it --name certbot -v "/docker-volumes/etc/letsencrypt:/etc/letsencrypt" -v "/docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/docker-volumes/data/letsencrypt:/data/letsencrypt" -v "/docker-volumes/var/log/letsencrypt:/var/log/letsencrypt" certbot/certbot renew --webroot -w /data/letsencrypt --quiet && docker kill --signal=HUP jenkins-nginx') | crontab -