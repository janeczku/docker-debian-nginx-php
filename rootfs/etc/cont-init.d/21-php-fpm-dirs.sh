#!/bin/sh

set -e

mkdir -p /data/tmp/php/uploads
mkdir -p /data/tmp/php/sessions
mkdir -p /data/tmp/nginx/fastcgi_cache
mkdir -p /data/tmp/nginx/fastcgi_cache_tmp
chown -R www:www /data/tmp/php /data/tmp/nginx/fastcgi_cache*
