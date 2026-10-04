## Script Prab
```
#!/bin/bash

# ===== Instalasi =====
apt-get update
apt-get install -y bind9 bind9-dnsutils

# ===== Soal 4: opsi BIND =====
cat > /etc/bind/named.conf.options << 'EOF'
options {
        directory "/var/cache/bind";
        forwarders { 192.168.122.1; };
        allow-query { any; };
        dnssec-validation no;
};
EOF

# ===== Soal 4: deklarasi zona master =====
cat > /etc/bind/named.conf.local << 'EOF'
zone "k32.com" {
    type master;
    file "/etc/bind/db.k32.com";
    notify yes;
    allow-transfer { 192.227.1.3; };
};

zone "1.227.192.in-addr.arpa" {
    type master;
    file "/etc/bind/rev.1";
    notify yes;
    allow-transfer { 192.227.1.3; };
};

zone "2.227.192.in-addr.arpa" {
    type master;
    file "/etc/bind/rev.2";
    notify yes;
    allow-transfer { 192.227.1.3; };
};

zone "3.227.192.in-addr.arpa" {
    type master;
    file "/etc/bind/rev.3";
    notify yes;
    allow-transfer { 192.227.1.3; };
};
EOF

# ===== Soal 4: file zona =====
cat > /etc/bind/db.k32.com << 'EOF'
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100103  ; serial
            604800      ; refresh
            86400       ; retry
            2419200     ; expire
            604800 )    ; negative cache

@       IN  NS  prab.k32.com.
@       IN  NS  tedd.k32.com.
@       IN  A   192.227.3.2
prab    IN  A   192.227.1.2
tedd    IN  A   192.227.1.3

rootkit IN  A   192.227.1.1
alpha   IN  A   192.227.4.2
beta    IN  A   192.227.4.3
gamma   IN  A   192.227.4.4
delta   IN  A   192.227.5.2
epsilon IN  A   192.227.5.3
abbey   IN  A   192.227.2.2
penny   IN  A   192.227.3.2
obladi  IN  A   192.227.1.4
desmond IN  A   192.227.1.5
oblada  IN  A   192.227.1.6
molly   IN  A   192.227.1.7

vault   IN  A   192.227.1.4
vault   IN  A   192.227.1.5

core    IN  A   192.227.1.6
core    IN  A   192.227.1.7

www     IN  CNAME   penny.k32.com.
static  IN  CNAME   abbey.k32.com.

EOF

cat > /etc/bind/rev.1 << 'EOF'
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100102  ; serial
            604800      ; refresh
            86400       ; retry
            2419200     ; expire
            604800 )    ; negative cache

@   IN  NS  prab.k32.com.
@   IN  NS  tedd.k32.com.

4   IN  PTR vault.k32.com.
5   IN  PTR vault.k32.com.
6   IN  PTR core.k32.com.
7   IN  PTR core.k32.com.

EOF

cat > /etc/bind/rev.2 << 'EOF'
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100101
            604800
            86400
            2419200
            604800 )

@   IN  NS  prab.k32.com.
@   IN  NS  tedd.k32.com.

2   IN  PTR abbey.k32.com.

EOF

cat > /etc/bind/rev.2 << 'EOF'
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100101
            604800
            86400
            2419200
            604800 )

@   IN  NS  prab.k32.com.
@   IN  NS  tedd.k32.com.

2   IN  PTR penny.k32.com.

EOF

# ===== Start service =====
named-checkconf && named-checkzone k32.com /etc/bind/db.k32.com
service named restart
```

## Script tedd
```
#!/bin/bash

# ===== Instalasi =====
apt-get update
apt-get install -y bind9 bind9-dnsutils

# ===== Soal 4: opsi BIND =====
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    dnssec-validation no;
    listen-on-v6 { any; };
};
EOF

# ===== Soal 4: deklarasi zona slave =====
cat > /etc/bind/named.conf.local << 'EOF'
zone "k32.com" {
    type slave;
    masters { 192.227.1.2; };
    file "/var/lib/bind/db.k32.com";
};

zone "1.227.192.in-addr.arpa" {
    type slave;
    masters { 192.227.1.2; };
    file "/var/lib/bind/rev.1";
};

zone "2.227.192.in-addr.arpa" {
    type slave;
    masters { 192.227.1.2; };
    file "/var/lib/bind/rev.2";
};

zone "3.227.192.in-addr.arpa" {
    type slave;
    masters { 192.227.1.2; };
    file "/var/lib/bind/rev.3";
};

EOF

# ===== Start service =====
named-checkconf
service named restart
```

## Script obladi
```
#!/bin/bash
apt-get update
apt-get install -y apache2
mkdir -p /arsip
echo "file 1 dari obladi" > /arsip/file1.txt
echo "file 2 dari obladi" > /arsip/file2.txt

cat > /etc/apache2/conf-available/arsip.conf << 'EOF'
ServerName obladi

Alias /arsip /arsip

<Directory /arsip>
    Options +Indexes
    Require all granted
</Directory>
EOF

a2enconf arsip
# ===== Soal 14 =====
a2enmod remoteip
cat > /etc/apache2/conf-available/remoteip.conf << 'EOF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.227.3.2
EOF
a2enconf remoteip

service apache2 restart
```

## Script desmond
```
#!/bin/bash
apt-get update
apt-get install -y apache2

mkdir -p /arsip
echo "file 1 dari desmond" > /arsip/file1.txt
echo "file 2 dari desmond" > /arsip/file2.txt

cat > /etc/apache2/conf-available/arsip.conf << 'EOF'
ServerName desmond

Alias /arsip /arsip

<Directory /arsip>
    Options +Indexes
    Require all granted
</Directory>
EOF

a2enconf arsip

# ===== Soal 14 =====
a2enmod remoteip
cat > /etc/apache2/conf-available/remoteip.conf << 'EOF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.227.3.2
EOF

a2enconf remoteip
service apache2 restart
```
## Script oblada
```
#!/bin/bash
# ===== Soal 10: instalasi =====
apt-get update
apt-get install -y nginx php-fpm

# ===== Soal 10: aplikasi =====
cat > /var/www/html/index.php << 'EOF'
<?php
echo "<h1>Beranda</h1>";
echo "<p>Dilayani oleh: " . gethostname() . "</p>";
?>
EOF
cat > /var/www/html/profil.php << 'EOF'
<?php
echo "<h1>Profil</h1>";
echo "<p>Kelompok: K-32</p>";
echo "<p>Dilayani oleh: " . gethostname() . "</p>";
?>
EOF

# ===== Soal 10: konfigurasi nginx =====
cat > /etc/nginx/sites-available/default << 'EOF'
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        server_name _;

        # Soal 14: catat IP asli pengunjung dari abbey
        set_real_ip_from 192.227.2.2;
        real_ip_header X-Real-IP;

        index index.php index.html;

        location / {
                rewrite ^/profil$ /profil.php last;
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;

                fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        }
}
EOF

# ===== Start service =====
service php8.4-fpm start
nginx -t && service nginx restart
```

## Script molly
```
#!/bin/bash
# ===== Soal 10: instalasi =====
apt-get update
apt-get install -y nginx php-fpm

# ===== Soal 10: aplikasi =====
cat > /var/www/html/index.php << 'EOF'
<?php
echo "<h1>Beranda</h1>";
echo "<p>Dilayani oleh: " . gethostname() . "</p>";
?>
EOF

cat > /var/www/html/profil.php << 'EOF'
<?php
echo "<h1>Profil</h1>";
echo "<p>Kelompok: K-32</p>";
echo "<p>Dilayani oleh: " . gethostname() . "</p>";
?>
EOF
# ===== Soal 10: konfigurasi nginx =====
cat > /etc/nginx/sites-available/default << 'EOF'
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        server_name _;

        # Soal 14: catat IP asli pengunjung dari abbey
            set_real_ip_from 192.227.2.2;
            real_ip_header X-Real-IP;

        index index.php index.html;

        location / {
                rewrite ^/profil$ /profil.php last;
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;

                fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        }
}
EOF
# ===== Start service =====
service php8.4-fpm start
nginx -t && service nginx restart
```

## Script abbey
```
#!/bin/bash
    server 192.227.1.6;

    server 192.227.1.6;


# ===== Instalasi =====
apt-get update
apt-get install -y nginx

# ===== Soal 15: folder dan halaman statis /orion =====
mkdir -p /var/www/orion
cat > /var/www/orion/index.html << 'EOF'
<h1>Orion</h1>
<p>Halaman statis dilayani langsung oleh abbey</p>
EOF

# ===== Soal 11 dan 15: konfigurasi nginx =====
cat > /etc/nginx/sites-available/default << 'EOF'
upstream backend_core {
    server 192.227.1.6;
    server 192.227.1.7;
}

server {
    listen 80;
    server_name static.k32.com;
    # Soal 15: dilayani abbey sendiri, tidak diteruskan
    location /orion/ {
        alias /var/www/orion/;
    }

    # Soal 11: reverse proxy ke area core
    location / {
        proxy_pass http://backend_core;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
server {
    listen 80 default_server;
    server_name _;
    return 302 http://static.k32.com$request_uri;
}
EOF

# ===== Start service =====
nginx -t && service nginx restart
```

## Script penny
```
# ===== Soal 11, 12, 13, 15: reverse proxy + redirect kanonik =====
cat > /etc/apache2/conf-available/proxy-vault.conf << 'EOF'
ServerName penny

<Proxy "balancer://vault">
    BalancerMember "http://192.227.1.4"
    BalancerMember "http://192.227.1.5"
    ProxySet lbmethod=byrequests
</Proxy>

# Soal 13: penangkap, harus VirtualHost pertama
<VirtualHost *:80>
    ServerName penny.k32.com
    Redirect permanent / http://www.k32.com/
</VirtualHost>

# Nama resmi
<VirtualHost *:80>
    ServerName www.k32.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    # Soal 12: basic auth untuk /admin
    <Location "/admin">
        AuthType Basic
        AuthName "Area Rahasia"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

    # Soal 15: /eternal dilayani penny sendiri
    Alias "/eternal" "/var/www/eternal"
    <Directory "/var/www/eternal">
        Require all granted
        <FilesMatch "\.php$">
            SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost"
        </FilesMatch>
    </Directory>

    ProxyPass "/eternal" !
    ProxyPass "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"
</VirtualHost>
EOF

a2enconf proxy-vault
a2dissite 000-default

# ===== Start service =====
service php8.4-fpm start
apache2ctl configtest && service apache2 restart
```
