# Laporan Praktikum Jarkom Modul 2
| Nama | NRP |
| ------------------ | ----------- |
| Anargya Shafa Setiyadi Putra | 5027251081 |
| Irsa Fairuza | 5027251115 |

##  Soal 1 Topologi
Sebagai pusat kesadaran The Mesh, rootkit harus merentangkan koneksinya ke lima gerbang utama (Switch). Tetapkan alamat IP dan default gateway untuk seluruh Entitas, mulai dari para operator (alpha, beta, gamma), penjaga directory (prab, tedd), gerbang penyaring (abbey, penny), hingga repository (obladi, desmond, oblada, molly) sesuai dengan topologi pembagian switch yang dirancang.

![alt text](dokumentasi/topologi.png)

Disini kami membuat router pusat (rootkit) menggunakan debinet untuk gateway seluruh perangkat, yaitu:
- Operator (Switch 6): alpha, beta, gama
- Penjaga directory (Switch 2): prab dan tedd
- Gerbang penyaring (Switch 4 dan 5): abbey dan penny
- Repository (Switch 3): obladi, desmond, oblada, molly

---

## Soal 2
Meskipun The Mesh beroperasi dalam bayang-bayang, Rootkit menyadari bahwa Entitas di dalamnya masih membutuhkan asupan paket dari dunia luar. Buka jalur menuju NAT dengan memastikan antarmuka WAN di router rootkit aktif. Konfigurasikan NAT agar dapat meneruskan lalu lintas keluar bagi seluruh alamat internal, sehingga semua host di dalam jaringan dapat menjangkau internet publik menggunakan IP address.

Untuk membuat semua host di dalam jaringan dapat mengakses internet publik, pertama eth0 rootkit kita sambungkan ke NAT dengan mengonfigurasi inet dhc dan default route via 192.168.122.1. Lalu kita isi IP forwarding serta `iptables` di /root/rootkit.sh dan panggil melalui konfigurasi dengan `up`

```
#!/bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || iptables -t
```
### pengujian

(gambar 2.2)

Lalu kita melakukan konfigurasi pada setiap node.

rootkit
```
auto eth0
iface eth0 inet dhcp
up bash /root/rootkit.sh

auto eth1
iface eth1 inet static
    address 192.227.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.227.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.227.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 192.227.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 192.227.5.1
    netmask 255.255.255.0
```

alpha
```
auto eth0
iface eth0 inet static
    address 192.227.4.2
    netmask 255.255.255.0
    gateway 192.227.4.1
```

beta
```
auto eth0
iface eth0 inet static
    address 192.227.4.3
    netmask 255.255.255.0
    gateway 192.227.4.1
```

gama
```
auto eth0
iface eth0 inet static
    address 192.227.4.4
    netmask 255.255.255.0
    gateway 192.227.4.1
```

prab
```
auto eth0
iface eth0 inet static
    address 192.227.1.2
    netmask 255.255.255.0
    gateway 192.227.1.1
```

tedd
```
auto eth0
iface eth0 inet static
    address 192.227.1.3
    netmask 255.255.255.0
    gateway 192.227.1.1
```

abbey
```
auto eth0
iface eth0 inet static
    address 192.227.2.2
    netmask 255.255.255.0
    gateway 192.227.2.1
```

penny
```
auto eth0
iface eth0 inet static
    address 192.227.3.2
    netmask 255.255.255.0
    gateway 192.227.3.1
```

obladi
```
auto eth0
iface eth0 inet static
    address 192.227.1.4
    netmask 255.255.255.0
    gateway 192.227.1.1
```

desmond
```
auto eth0
iface eth0 inet static
    address 192.227.1.5
    netmask 255.255.255.0
    gateway 192.227.1.1
```

oblada
```
auto eth0
iface eth0 inet static
    address 192.227.1.6
    netmask 255.255.255.0
    gateway 192.227.1.1

```

molly
```
auto eth0
iface eth0 inet static
    address 192.227.1.7
    netmask 255.255.255.0
    gateway 192.227.1.1
```

delta
```
auto eth0
iface eth0 inet static
    address 192.227.5.2
    netmask 255.255.255.0
    gateway 192.227.5.1
```

epsilon
```
auto eth0
iface eth0 inet static
    address 192.227.5.3
    netmask 255.255.255.0
    gateway 192.227.5.1
```

---

## Soal 3
Jaringan rahasia tidak akan berfungsi tanpa sinkronisasi antar divisi. Pastikan seluruh Entitas dapat saling terhubung dan berkomunikasi lintas jalur (routing internal via rootkit berfungsi). Untuk menghindari fragmentasi saat persiapan, pastikan setiap host non-router menambahkan resolver 192.168.122.1 (tambah di file /etc/resolv.conf, kalau sudah pakai resolver itu tidak perlu memasukkan resolver google) saat antarmukanya aktif agar akses untuk mengunduh paket instalasi dari internet tersedia sejak awal beroperasi.

Disini kita mengonfigurasi tiap host dengan:
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

Lalu dilakukan pengujian lintas jalur
(gambar3 komunikasi lintas jalur)

---

## Soal 4
Penjaga Direktori mulai menuliskan hukum The Mesh. Pada node prab, bangun zona <xxxx>.com sebagai authoritative dengan SOA yang menunjuk ke prab.<xxxx>.com, serta tambahkan catatan NS untuk prab.<xxxx>.com dan tedd.<xxxx>.com. Buat A record untuk prab.<xxxx>.com dan tedd.<xxxx>.com yang mengarah ke alamat IP mereka masing-masing, serta A record apex <xxxx>.com yang mengarah ke gerbang aplikasi dinamis (penny). Aktifkan fitur notify dan allow-transfer ke tedd, lalu set forwarders ke 192.168.122.1. Di node tedd, tarik zona <xxxx>.com dari master dan pastikan server menjawab secara authoritative. Setelah fondasi nama ini berdiri kokoh, perbarui urutan resolver pada seluruh Entitas non-router menjadi: IP prab, IP tedd, lalu 192.168.122.1. Verifikasi bahwa query ke domain apex maupun hostname di dalam zona dijawab dengan benar oleh prab atau tedd. 

Disini kita membuat DNS untuk k32.com. Prab sebagai server utama (master) dan tedd sebagai server cadangan (slave). Semua host non router nantinya diarahkan ke dua server ini.

### a. Node prab
Pertama kita memasang bind9
```
apt-get update
apt-get install -y bind9 bind9-dnsutils
```

Selanjutnya kita deklarasi zona di prab
```
zone "k32.com" {
    type master;
    file "/etc/bind/db.k32.com";
    notify yes;
    allow-transfer { 192.227.1.3; };
};
```
disini notify yes memberitahu tedd kalau zonanya berubah dan allow transfer menentukan hanya ted yang bisa menarik salinan karena tedd sebagai server cadangan.

Lalu membuat file untuk zona di prab
```
nano /etc/bind/db.k32.com
```

Isi file sebagai berikut
```
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100101  ; serial
            604800      ; refresh
            86400       ; retry
            2419200     ; expire
            604800 )    ; negative cache

@       IN  NS  prab.k32.com.
@       IN  NS  tedd.k32.com.
@       IN  A   192.227.3.2
prab    IN  A   192.227.1.2
tedd    IN  A   192.227.1.3
```

- SOA menunjuk prab.k32.com.
- @ IN A 192.227.3.2 adalah apex ke penny gerbang aplikasi dinamis
- serial erial 2026100101 dinaikan setiap kali file ini diubah.

Selanjutnya membuat forwarders di prab dengan mengedit file /etc/bind/named.conf.options
```
forwarders { 192.168.122.1; };
allow-query { any; };
dnssec-validation no;
```

Selanjutnya melakukan pengecekan di prab
```
named-checkconf
named-checkzone k32.com /etc/bind/db.k32.com
service named start
```
(gambar 4.1)
Ditunjukan bahwa zoma sudah sesuai

```
ping k32.com
```
(gambar 4.6)

ping ke k32 berhasil menandakan bahwa DNS resolver bekerja dengan baik

### Node tedd
Disini kita pasang juga bind9 lalu deklarasi zona sebagai type slave dengan master `192.227.1.2` (server di prab).
```
zone "k32.com" {
    type slave;
    masters { 192.227.1.2; };
    file "/var/lib/bind/db.k32.com";
};
```

Selanjutnya kita restart bind9 untuk memperbarui
```
service bind9 restart
```

Lalu kita test di node tedd
(gambar 4.7)

Kemudian kita ubah urutan resolver semua node non-router menjadi 

prab -> tedd -> 192.168.122.1

Ini dilakukan dengan mengubah up pada configurasi tiap node menjadi
```
up echo -e "nameserver 192.227.1.2\nnameserver 192.227.1.3\nnameserver 192.168.122.1" > /etc/resolv.conf
```

(gambar 4.4 dan 4.8)

Dengan pengujian ini terlihat urutan resolver sudah sesuai dan test dari alpha berhasil

---

## Soal 5
"Entitas tanpa identitas adalah anomali," pesan Rootkit. Namai semua Entitas (hostname) sesuai glosarium: rootkit, alpha, beta, gamma, delta, epsilon, prab, tedd, abbey, penny, obladi, desmond, oblada, molly, dan verifikasi bahwa setiap host mengenali hostname tersebut secara system-wide. Buat setiap domain untuk masing-masing node sesuai dengan namanya (contoh: alpha.<xxxx>.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas prab dan tedd.

Disini kita membuat hostname pada tiap node dan nama domain di zona k32.com yang mengarahkan ke IP node tersebut (kecuali node prab dan tedd).

### Hostname
Pada GNS3 nama node sudah otomatis menjadi hostname yang disimpan dalam `/etc/hosts`. 

### A Record
Untuk menentukan nama domain dan mengarahkan ke alamat IP, kita membuat domain sesuai nama dan IP di file zona db.k32.com pada node prab. Tidak lupa untuk menaikan serial SOA agar tedd menyalin isi yang baru ini.

```
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100102  ; serial
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
```

Setelah script dijalankan ulang, kita memastikannya dengan cek hostname dari salah satu node dengan
```
hostname
cat /etc/hostname
cat /etc/hosts
getent hosts $(hostname)
```

(gambar 5.1)

Disini kita mencoba pada node alpha, ditunjukan bahwa hostname sudah sesuai dengan nama node dan hostname sudah dikenali sistem.

## Soal 6
Pastikan zone transfer berjalan, pastikan tedd telah menerima salinan zona terbaru dari prab. Nilai serial SOA di keduanya harus sama karena keduanya tidak bisa dipisahkan dan saling melengkapi.

Pertama kita harus memastikan serial SOA dari prab dan tedd sama
```
dig @192.227.1.2 k32.com SOA +short
dig @192.227.1.3 k32.com SOA +short
```

(gambar 6.1)

Terlihat bahwa serial SOA pada prab dan tedd sama yaitu `2026100103`

Selanjutnya kita lihat apakah tedd menjawab secara authoritative
```
dig @192.227.1.3 k32.com SOA | grep flags
```

(gambar 6.2)

Terlihat bahwa tedd menjawab secara authoritative dari salinan zona miliknya sendiri.

Terakhir kita pastikan tedd menerima salinan zona dari prab
```
ls -l /var/lib/bind/
```

(gambar 6.3)

Terlihat bahwa `db.k32.com` sudah ada di `var/lib/bind/` pada tedd menunjukan file itu hasil zona transfer.

## Soal 7
abbey dan penny sebagai gerbang utama, obladi dan desmond sebagai web statis, oblada dan molly sebagai web dinamis. Tambahkan pada zona <xxxx>.com A record untuk vault.<xxxx>.com (IP obladi & desmond), dan core.<xxxx>.com (IP oblada & molly). Tetapkan CNAME:
www.<xxxx>.com → penny.<xxxx>.com
static.<xxxx>.com → abbey.<xxxx>.com
Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.

Disini kita menambahkan vault untuk web statis, core untuk web dinamis, dan alias www dan static untuk dua gerbang utama pada zona k32.com di prab

```
nano /etc/bind/db.k32.com
```

- Menambahkan A Record untuk Area Vault
```
vault   IN  A   192.227.1.4
vault   IN  A   192.227.1.5
```

- Menambahkan A Record untuk Area Core
```
core    IN  A   192.227.1.6
core    IN  A   192.227.1.7
```

- Menambahkan CNAME Record
```
www     IN  CNAME   penny.k32.com.
static  IN  CNAME   abbey.k32.com.
```

Setelah file diganti naikan serial SOA, lalu dicek di dua node berbeda.
```
host vault.k32.com
host core.k32.com
host www.k32.com
host static.k32.com
```
(gambar 7.1 dan 7.2)

disini vault menjawab 192.227.1.4 dan .5, core menjawab .6 dan .7, www beralias ke penny (192.227.3.2), static beralias ke abbey (192.227.2.2).

---

## Soal 8
Di prab (master) deklarasikan reverse zone untuk segmen jaringan  tempat abbey, penny, area vault, dan area core berada. Di tedd (slave) tarik reverse zone tersebut sebagai slave, isi PTR untuk keempat hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat abbey, penny, area vault, dan area core dijawab authoritative.

Disini kita buat reverse zone (IP ke nama) dan dijawab secara authoritative dari prab dan tedd.

Pertama kita deklarasi reverse zone di prab pada file `/etc/bind/named.conf.local`
```
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
```
Reverse lookup memakai domain khusus `in-addr.arpa`, dengan IP ditulis terbalik.

Selanjutnya kita buat file reverse zone di prab. Karena alamat IP disini ada tiga segmen (area vault/core (192.227.1.x), abbey (192.227.2.x), dan penny (192.227.3.x)) kita membuat tiga ruang zona tersendiri untuk reverse lookup ini.

- File /etc/bind/rev.1 (area vault & core):
```
$TTL 604800
@   IN  SOA prab.k32.com. root.k32.com. (
            2026100101  ; serial
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
```

- File /etc/bind/rev.2 (abbey):
```
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
```

- File /etc/bind/rev.3 (penny):
```
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
```

Lalu validasi zona tiap file
```
named-checkzone 1.227.192.in-addr.arpa /etc/bind/rev.1
named-checkzone 2.227.192.in-addr.arpa /etc/bind/rev.2
named-checkzone 3.227.192.in-addr.arpa /etc/bind/rev.3
```

(gambar 8.1)

Dilanjut dengan deklarasi reverse zone di tedd (slave) pada file /etc/bind/named.conf.local. tambahkan deklarasi untuk menarik salinan ketiga zona reverse dari prab.

```
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
```
Lalu dilakukan pengujian ke prab dan tedd (di alpha)
```
for ip in 192.227.2.2 192.227.3.2 192.227.1.4 192.227.1.5 192.227.1.6 192.227.1.7; do echo "== $ip"; dig -x $ip @192.227.1.3 | grep -E "flags|PTR"; done
```

(gambar 8.2)

---

## Soal 9
Jalankan layanan web statis pada hostname di node area vault (menggunakan apache). Buka folder direktori /arsip/ dan aktifkan fitur autoindex (directory listing) pada konfigurasi Apache sehingga seluruh daftar file di dalamnya dapat ditelusuri langsung dari browser. Akses pengujian harus dilakukan melalui hostname, bukan IP address.

Pertama kita memasang apache
```
apt-get update
apt-get install -y apache2
```

Lalu jalankan apache nya
```
service apache2 start
```

Setelah itu membuat folder arsip berisi file1.txt dan file2.txt
```
mkdir -p /arsip
echo "file 1 dari obladi" > /arsip/file1.txt
echo "file 2 dari obladi" > /arsip/file2.txt
```
Nama file dibedakan agar bisa mengetahui nanti siapa yang menjawab bergantian dari obladi dan desmond.

selanjutnya kita buat konfigurasi untuk apache pada file `/etc/apache2/conf-available/arsip.conf`
```
ServerName obladi

Alias /arsip /arsip

<Directory /arsip>
    Options +Indexes
    Require all granted
</Directory>
EOF
```
Disini URL `/arsip` dipetakan ke folder fisik, `Options +Indexes` mengaktifkan fitur autoindex. 

Selanjutnya kita mengaktifkan konfigurasi, cek sintaks, dan coba jalankan.
```
a2enconf arsip
apache2ctl configtest
service apache2 restart
```

(gambar 9.12 bukti)

Kemudian kita uji node obladi dan desmond
```
curl -s http://vault.k32.com/arsip/ | grep -E "Index of|file"
```

(gambar 9.10 dan 9.11 atau take ulang)

Lalu kita uji lewat hostname dari klienn alpha
```
host vault.k32.com
curl http://vault.k32.com/arsip/
curl http://vault.k32.com/arsip/file1.txt
```

(gambar 9.13.1,2,3)

---

## Soal 10
Jalankan layanan web dinamis (PHP-FPM) pada hostname di node core (menggunakan nginx). Buat sebuah aplikasi sederhana yang memuat halaman beranda dan halaman profil. Terapkan aturan rewrite pada server sehingga akses ke /profil dapat berfungsi dengan URL bersih (tanpa akhiran .php). Akses pengujian wajib dilakukan melalui hostname.

Disini kita jalankan web dinamis di node core (oblada dan molly) yang isinya beranda dan profil.

Pertama, instal nginx dan PHP-FPM untuk menjalankan web dinamis pada node core
```
apt-get update
apt-get install -y nginx php-fpm
```

Lalu mumbuat aplikasi beranda dan profil
```
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
```

Dilanjut dengan konfigurasi nginx agar profil.php dan beranda.php dapat diproses oleh PHP-FPM dan akses ke /profil bisa berfungsi dengan URL bersih.

```
cat > /etc/nginx/sites-available/default << 'EOF'
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        server_name _;

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
```

Selanjutnya kita jalankan PHP-FPPM dan nginx
```
service php8.4-fpm start
nginx -t && service nginx restart
```

Untuk pengujian pertama kita uji dari node itu sendiri
```
curl http://localhost/
curl http://localhost/profil
curl http://localhost/profil.php
```

(gambar 10.7)

Disini nginx ............

Lanjut dengan uji lewat hostname dari alpha
```
host core.k32.com
curl http://core.k32.com/
curl http://core.k32.com/profil
curl http://oblada.k32.com/profil
curl http://molly.k32.com/profil
```
*kalo bisa pake command lynx

(gambar 10.8.1-5)

Hasil uji:

host core.k32.com ..........

## Soal 11
Konfigurasikan Penny (menggunakan Apache) sebagai reverse proxy yang mengarah ke semua node di area vault (Obladi & Desmond). Sementara itu, konfigurasikan Abbey (menggunakan Nginx) sebagai reverse proxy menuju area core (Oblada & Molly). Pastikan kedua gerbang ini meneruskan identitas asli pengunjung ke server backend dengan melakukan forwarding header Host dan X-Real-IP. Buktikan bahwa Penny dan Abbey berhasil mendistribusikan lalu lintas dengan tepat.

Disini kita konfigurasi penny (apache) sebagai reverse proxy ke obladi dan desmond. Lalu abbey (nginx) sebagai reverse proxy ke oblada dan molly. Kemudian membagi lalu lintas ke backend dan meneruskan identitas asli pengunjung lewat header Host dan X-Real-IP

### a. abbey ke area core
Pertama kita pasang nginx
```
apt-get update
apt-get install -y nginx
```

Lalu atur konfigurasi proxy
```
cat > /etc/nginx/sites-available/default << 'EOF'
upstream backend_core {
    server 192.227.1.6;
    server 192.227.1.7;
}

server {
    listen 80;
    server_name static.k32.com;

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
nginx -t
```

Untuk menjalankannya menggunakan perintah berikut
```
service nginx restart
```

Selanjutnya kita melakukan pengujian dari node alpha
- resolve gerbang
```
host www.k32.com
host static.k32.com
```

(gambar 11.7)

- pembagian lalu lintas
```
curl -s http://static.k32.com/
curl -s http://static.k32.com/
curl -s http://static.k32.com/
curl -s http://static.k32.com/

```

(ulang 6x)

(gambar 11.8)

Terlihat hasilnya ada "dilayani oleh" yang bergantian antara oblada dan molly. Ini menunjukan bahwa abbey membagi lalu lintas ke dua backend. Kalau hanya ada satu nama yang muncul, berarti salah satu backend nya mati. Kalau 502, berarti semua backend tidak terjangkau.

### b. penny ke area vault
Sama seperti di abbey, kita pasang apache dan aktifkan modul proxy
```
apt-get update
apt-get install -y apache2
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers
```

Lalu kita masukan konfigurasi proxy
```
cat > /etc/apache2/conf-available/proxy-vault.conf << 'EOF'
ServerName penny

<Proxy "balancer://vault">
    BalancerMember "http://192.227.1.4"
    BalancerMember "http://192.227.1.5"
    ProxySet lbmethod=byrequests
</Proxy>

<VirtualHost *:80>
    ServerName www.k32.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    ProxyPass "/" "balancer://vault/"
    ProxyPassReverse "/" "balancer://vault/"
</VirtualHost>
EOF
a2enconf proxy-vault
a2dissite 000-default
apache2ctl configtest
```

Lanjut jalankan apache
```
service apache2 restart
```

Lalu lakukan pengujian di alpha
```
curl -s http://www.k32.com/arsip/file1.txt
```

(ulang 6x)

(gambar 11.9)

Ini juga akan menunjukan lalulintas yang dibagi ke dua backend yaitu obladi dan desmond.

Selanjutnya kita membuktikan identitas asli sampai ke backend setelah melakukan request dari alpha.
- di obladi/ desmond
```
tail -n 3 /var/log/apache2/access.log
```

- di oblada/ molly
```
tail -n 3 /var/log/nginx/access.log
```

(gambar 11.10.1 dan 2)

Terlihat kolom bukan diisi dengan penny atau abbey, melainkan IP 192.227.4.2 (IP alpha). Membuktikan kalau X-Real-IP diteruskan dan dipakai backend.

## Soal 12
Terdapat ruang khusus di penny yang yang menyimpan dokumen rahasia sindikat, oleh karena itu terapkan perlindungan basic authentication untuk path /admin. Akses ke jalur tersebut harus menolak pengunjung tanpa kredensial, dan hanya mengizinkan masuk jika menggunakan credential berikut:

| Username | Password |
| ----------- | ----------- |
| prabs | pakar_pinter_jadi_gob*** |

Disini kita mengharuskan pengunjung menggunakan kredensial yang boleh masuk (dengan user prabs) dengan menyimpan username dan hash password yang dibuat dengan `htpasswd`. Aturan ini ditaruh di VirtualHost www.k32.com supaya berlaku untuk nama yg resmi.

Pertama kita install alat pembuat file password dan mengaktifkan modul autentikasi
```
apt-get install -y apache2-utils
a2enmod auth_basic authn_file authz_user
```

Lalu kita membuan file password
```
htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'
cat /etc/apache2/.htpasswd
```

Selanjutnya kita menambah konfigurasi blok proteksi di VirtualHost www.k32.com pada `/etc/apache2/conf-available/proxy-vault.conf`
```
    <Location "/admin">
        AuthType Basic
        AuthName "Area Rahasia"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>
```

Lalu kita cek dan terapkan konfigurasi
```
apache2ctl configtest
service apache2 restart
```

Selanjutnya kita uji pada node alpha
```
curl -i http://www.k32.com/admin
curl -i -u 'prabs:salah' http://www.k32.com/admin
curl -i -u 'prabs' http://www.k32.com/admin
```

(gambar 12.6.1-3)
Hasil pertama pengunjung tanpa kredensial ditolak. Kedua, pengunjung yang passwordnya salah juga ditolak. Ketiga, pengunjung dengan kredensial yang sesuai autentikasi nya lolos dan request diteruskan ke obladi/ desmond.

---

## Soal 13
Setiap entitas dari luar harus memanggil gerbang dengan nama kanoniknya. Jika ada yang mencoba mengakses IP penny dan domain  penny.xxx.com, paksa sistem untuk melakukan redirect secara permanen (status code 301) menuju www.xxx.com. Sebaliknya, jika ada yang mengakses IP abbey dan domain abbey.xxx.com, lakukan redirect sementara (status code 302) menuju static.xxx.com.

Disini kita memaksa pengunjung memakai nama kanonik gerbang. Akses lewat IP penny atau penny.k32.com dialihkan permanen 301 ke www.k32.com, dan akses lewan IP abbey atau abbey.k32.com dialihkan sementara 302 ke static.k32.com. Untuk itu di nginx, penangkap adalah blok server dengan default_server dan di apache, penangkap adalah VirtualHost yang didefinisikan pertama.

### pada abbey (redirect 302)
Langkah pertama kita ubah konfigurasi jadi ada dua blok server
```
cat > /etc/nginx/sites-available/default << 'EOF'
upstream backend_core {
    server 192.227.1.6;
    server 192.227.1.7;
}

server {
    listen 80;
    server_name static.k32.com;

    location /orion/ {
        alias /var/www/orion/;
    }

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
nginx -t
```

Setelah itu terapkan
```
service nginx restart
```

Lalu kita uji dari node alpha
```
curl -i http://192.227.2.2/
curl -i http://abbey.k32.com/
curl -i http://static.k32.com/
```

(gambar 13.1.1-3)

Terlihat hasil pertama dan kedua adalah 302 Found dengan `Location: http://static.k32.com/` yang artinya IP dan nama non kanonik dialihkan sementara. Lalu hasil yang ketiga 200 yang artinya nama kanonik dilayani.

### pada penny (redirect 301)
Pada konfigurasi kita pecah menjadi dua VirtualHost, yang penangkap harus dituilis di awal. Di VirtualHost penangkap, ServerName hanya label. Karena dia yang pertama, dia jadi default untuk Host yang tidak cocok.

```
cat > /etc/apache2/conf-available/proxy-vault.conf << 'EOF'
ServerName penny

<Proxy "balancer://vault">
    BalancerMember "http://192.227.1.4"
    BalancerMember "http://192.227.1.5"
    ProxySet lbmethod=byrequests
</Proxy>

# Penangkap: harus VirtualHost pertama
<VirtualHost *:80>
    ServerName penny.k32.com
    Redirect permanent / http://www.k32.com/
</VirtualHost>

# Nama kanonik
<VirtualHost *:80>
    ServerName www.k32.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    <Location "/admin">
        AuthType Basic
        AuthName "Area Rahasia"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

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
apache2ctl configtest
```

Kemudian kita terapkan dan kita cek urutan virtual host nya
```
service apache2 restart
apache2ctl -S
```

Selanjutnya kita uji dari node alpha
```
curl -i http://192.227.3.2/
curl -i http://penny.k32.com/
curl -i http://www.k32.com/arsip/file1.txt
```

(gambar 13.2.1-3)

Terlihat hasil yang pertama dan kedua adalah 301 Moved Permanently dengan `Location: http://www.k32.com/`, dan hasil yang ketiga 200 beserta isi file berarti nama kanonik tetap dilayani dan proxy nya aman.

---

## Soal 14
Di dalam The Mesh, rekam jejak tidak boleh dipalsukan oleh sistem. Pastikan access log pada setiap server web di area vault maupun area core mencatat alamat IP asli milik client (pengunjung) yang diteruskan oleh gerbang, dan bukan mencatat IP dari Penny ataupun Abbey.

Disini kita pastikan akses log di obladi, desmond, oblada, dan molly mencatat IP asli pengunjung bukan IP gerbang. Ini dilakukan dengan gerbang yang menitipkan IP asli lewat X-Real-IP, dan backend yang membaca header tersebut untuk dipakai sebagai IP klien.

### a. gerbang ngirim header
- pada penny di dalam VirtualHost www.k32.com
```
RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}
```

- pada abbey di dalam location /
```
proxy_set_header X-Real-IP $remote_addr;
```

### b. di obladi dan desmond
Disini kita aktifkan modul dan tulis konfigurasi
```
a2enmod remoteip
cat > /etc/apache2/conf-available/remoteip.conf << 'EOF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.227.3.2
EOF
a2enconf remoteip
```

Lalu kita cek dan terapkan
```
apache2ctl configtest
service apache2 restart
```

### di oblada dan molly
Disni kita tambahkan baris ini ke dalam blok server pada ` /etc/nginx/sites-available/default`
```
set_real_ip_from 192.227.2.2;
real_ip_header X-Real-IP;
```

Lalu jalankan
```
set_real_ip_from 192.227.2.2;
real_ip_header X-Real-IP;
```

### uji backend
```
tail -n 3 /var/log/apache2/access.log     (obladi, desmond)
tail -n 3 /var/log/nginx/access.log       (oblada, molly)
```
(gambar 14.3.1-2)

kolom IP paling kiri berisi 192.227.4.2 (alpha), bukan 192.227.3.2 atau 192.227.2.2. Berarti backend memakai IP asli dari header.

* catatan (hapus nanti)
Backend	Gerbang	IP di log sebelum	IP di log sesudah
obladi, desmond	penny	192.227.3.2	192.227.4.2
oblada, molly	abbey	192.227.2.2	192.227.4.2

---

## Soal 15
Rootkit menginstruksikan pembuatan jalur proxy khusus yang berdiri sendiri. Pada penny buat reverse proxy untuk path /eternal yang menyajikan directory /var/www/eternal, dan pastikan path ini dapat mengeksekusi (rendering) file php. Pada abbey, buat jalur /orion yang menyajikan directory /var/www/orion, secara murni statis tanpa perlu rendering php.

Disini kita membuat dua jalur yang dilayani oleh gerbang langsung, gak diteruskan ke backend (`/eternal` di penny dan `/orion` di abbey)

### a. di penny
Pertama kita pasang PHP-FPM dann aktifkan modul
```
apt-get install -y php-fpm
a2enmod proxy_fcgi
```

Lalu kita buat dolder dan file PHP untuk di uji
```
mkdir -p /var/www/eternal
cat > /var/www/eternal/index.php << 'EOF'
<?php
echo "<h1>Eternal</h1>";
echo "<p>PHP dijalankan langsung oleh " . gethostname() . "</p>";
?>
EOF
```

disini `ls /var/www/eternal` menampilkan index.php, memanggil gethostname() supaya terlihat penny sendiri yang menjalankan PHP, bukan obladi atau desmond.


Selanjutnya tambahkan di VirtualHOst www.k32.com di atas `ProxyPass "/"`
```
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
```

Kemudian jalankan PHP-FPM, cek, dan terapkan
```
service php8.4-fpm start
apache2ctl configtest
service apache2 restart
ls /run/php/
```

Terakhir kita uji dari alpha
```
curl -i http://www.k32.com/eternal/
```

(gambar 15.2)

Terlihat hasilnya menampilkan header "eternal" dan isinya bukan kode php tapi "PHP dijalankan langsung oleh penny" yang artinya PHP dirender oleh penny.

### di abbey
Pertama kita buat folder dan halaman statis
```
mkdir -p /var/www/orion
cat > /var/www/orion/index.html << 'EOF'
<h1>Orion</h1>
<p>Halaman statis dilayani langsung oleh abbey</p>
EOF
```

Lalu tambahkan di blok `server static.k32.com` di atas `location /`
```
    location /orion/ {
        alias /var/www/orion/;
    }
```

Lanjut cek dan terapkan
```
nginx -t
service nginx restart
```

Terakhir kita uji dari alpha
```
curl -i http://static.k32.com/orion/
```

(gambar 15.3)

Terlihat `/orion/` menjawab 200 OK dengan server nginx dan header  "Orion" dan isinya "dilayani langsung oleh abbey" artinya abbey menjawab sendiri.
