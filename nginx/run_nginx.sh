#!/usr/bin/env bash
envsubst '\$JENKINS_HOST' < /nginx.conf.template > /etc/nginx/conf.d/default.conf
exec nginx -g "daemon off;"
