nginx-app
=========

nginx-app was created to configure (new) rails apps in a quick and easy way.

Short setup
-----------

nginx, puma (or whatever) with Procfile (foreman).

Why
---

Because pow is a wonderful idea, but too slow in my expercience.

Install nginx / dnsmasq
-----------------------

```
brew install nginx
sudo ln -sfv /usr/local/opt/nginx/*.plist /Library/LaunchDaemons
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

Add the following to `/urs/local/etc/nginx/nginx.conf`

```
# Load all vhosts !
include /usr/local/etc/nginx/sites/*.conf;
```

```
brew install dnsmasq

echo 'address=/.dev/127.0.0.1' > /usr/local/etc/dnsmasq.conf

sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist



Usage
-----

Run `nginx-app` in the app root. 

A nginx server conf (app.dev) will be created which proxies all app requests to a unix {app-name} unix socket. At the same time a Procfile will be created with a web config on the same socket.

Run `sudo nginx -s reload` to load the new config.

Next, one starts the app with `foreman start -f Procfile.local` and point the browser to `http://app.dev`.

Author
------

Socket-idea by Bob Van Landuyt - @Reprazent

Koen Van der Auwera - @atog
