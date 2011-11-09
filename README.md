nginx-app
=========

nginx-app was created to configure (new) rails apps in a quick and easy way.

Short setup
-----------

nginx, unicorn (or whatever) with Procfile (foreman).

Why
---

Because pow is a wonderful idea, but too slow in my expercience.

BIND and local dev domain
-------------------------

Special thanks to [Jesse Dearing](http://jessedearing.com/nodes/9)
All steps listed below:

```
$ sudo -s
$ rndc-confgen > /etc/rndc.conf
$ head -n5 /etc/rndc.conf |tail -n4 > /etc/rndc.key
```

create `/etc/named.conf`

```
zone "dev" IN {
   type master;
   file "dev.zone";
   allow-update { none; };
 };
```

create `/var/named/dev.zone`

```
$TTL  60
$ORIGIN dev.
@      1D IN SOA localhost. root.localhost. (
         42   ; serial (d. adams)
         3H   ; refresh
         15M    ; retry
         1W   ; expiry
         1D )   ; minimum

     1D IN NS localhost
     1D IN A    127.0.0.1
localhost.dev. 60 IN A 127.0.0.1
*.dev. 60 IN A 127.0.0.1
```

```
$ launchctl load -w /System/Library/LaunchDaemons/org.isc.named.plist
$ named
```

create `/etc/resolver/dev`

`nameserver 127.0.0.1`

On Lion add 127.0.0.1 to the list of DNS servers in Network


Usage
-----

Run `nginx-app` is the app root. 

A nginx server conf (app.dev) will be created which proxies all app requests to the _next_ 8000+ port on `127.0.0.1`. At the same time a Procfile will be created with a web config on the same port.

Next, one starts the app with `foreman start` and point the browser to `http://app.dev`.

Author
------

Koen Van der Auwera - @atog