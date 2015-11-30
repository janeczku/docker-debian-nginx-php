## Debian Nginx/PHP-FPM image

Nginx/PHP-FPM Docker image - based on Debian Wheezy

This is the [janeczku/debian-nginx-php](https://registry.hub.docker.com/u/janeczku/debian-nginx-php/) Docker image providing Nginx 1.8 (Dotdeb) and PHP-FPM 5.6 with a well organized configuration layout tuned for great performance.

#### Docker Hub trusted builds

[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/janeczku/debian-nginx-php/latest.svg)](https://hub.docker.com/r/janeczku/debian-nginx-php/)

-----------
## Features

### Nginx 1.8 (Dotdeb)

This image is based on [janeczku/debian-nginx](https://github.com/janeczku/docker-debian-nginx) - go there for more details.  
**Default host** is configured and served from `/data/www/default`. Add .php file to that location to have it executed with PHP.

### PHP-FPM 5.6

**PHP 5.6** is up & running for the default host. See [/etc/nginx/conf.d/php-location.conf](rootfs/etc/nginx/conf.d/php-location.conf).

[/etc/nginx/fastcgi_params](rootfs/etc/nginx/fastcgi_params) has been tweaked to work well with most PHP applications.

### Error logging

Nginx and PHP error logs are available via `docker logs [container]`.
In addition, they are logged to `/data/logs/nginx-error.log`. PHP-FPM logs are available in `/data/logs/php-fpm*.log`. 

### Directory structure
```
/data/www # Web content
/data/www/default # Root directory for the default host
/data/logs/ # Nginx, PHP logs
/data/tmp/php/ # PHP temp directories
```

### Pre-defined FastCGI cache for PHP backend

A PHP location with FastCGI caching can be created like this:
```
location ~ \.php$ {
    # Your standard directives...
    include               fastcgi_params;
    fastcgi_pass          php-upstream;
    
    # Use the configured cache (adjust fastcgi_cache_valid to your needs):
    fastcgi_cache         APPCACHE;
    fastcgi_cache_valid   60m;
}
```

## Usage

### Quick Start

```
docker run -d --name=web -p=80:80 -p=443:443 -e GENERATE_DEFAULT_HOST=true janeczku/debian-nginx-php
```

### By creating a new image and embedding the web content

	FROM janeczku/debian-nginx-php
	ADD webroot /data/www/default
	ADD default-host.conf /data/conf/nginx/hosts.d/

### By mounting a data container

```
docker run -d --name=web-data -v /data busybox
docker run -d --name=web --volumes-from=web-data -p=80:80 janeczku/debian-nginx-php
```

## Customise

* See [janeczku/debian-nginx](https://github.com/janeczku/docker-debian-nginx) for info regarding Nginx customisation, adding new vhosts etc.
* Override `/etc/nginx/fastcgi_params` if needed.
* Add own PHP-FPM .conf files to `/data/conf/php-fpm-www-*.conf` to modify PHP-FPM www pool.


## ENV variables

**GENERATE_DEFAULT_HOST**  
Default: `GENERATE_DEFAULT_HOST=false`  
Example: `GENERATE_DEFAULT_HOST=true`  
When set to `true`, a default Nginx host config file will be generated in `/etc/nginx/hosts.d/default.conf`. In addition, default index.php file will be created displaying results of `phpinfo()`.