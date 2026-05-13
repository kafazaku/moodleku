# Panduan Instalasi Moodle 5.2

Dokumen ini berisi langkah-langkah detail untuk menginstal Moodle di berbagai platform.

## 📱 Quick Start (Docker)

Instalasi tercepat menggunakan Docker:

```bash
# 1. Clone repository
git clone https://github.com/kafazaku/moodleku.git
cd moodleku

# 2. Copy environment file
cp .env.example .env

# 3. Edit .env dengan konfigurasi Anda
nano .env

# 4. Start containers
docker-compose up -d

# 5. Buka di browser
# http://localhost
```

---

## 🖥️ Instalasi Manual di Linux (Ubuntu/Debian)

### 1. Update System
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 2. Install Dependencies
```bash
sudo apt-get install -y \
  php8.3 php8.3-cli php8.3-fpm \
  php8.3-mysql php8.3-pgsql \
  php8.3-curl php8.3-gd php8.3-zip \
  php8.3-xml php8.3-mbstring \
  php8.3-intl php8.3-soap \
  php8.3-pecl-sodium \
  nginx \
  mysql-server \
  curl wget git
```

### 3. Configure PHP
```bash
# Edit php.ini
sudo nano /etc/php/8.3/fpm/php.ini
```

Set berikut nilai:
```ini
memory_limit = 512M
upload_max_filesize = 50M
post_max_size = 50M
max_execution_time = 300
max_input_vars = 5000
```

Restart PHP-FPM:
```bash
sudo systemctl restart php8.3-fpm
```

### 4. Setup Database
```bash
# Login ke MySQL
sudo mysql -u root

# Buat database dan user
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'secure_password_123';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 5. Download & Extract Moodle
```bash
cd /var/www
sudo wget https://download.moodle.org/download.php/direct/stable42/moodle-5.2.tgz
sudo tar -xzf moodle-5.2.tgz
sudo rm moodle-5.2.tgz
```

### 6. Create Moodle Data Directory
```bash
sudo mkdir -p /var/moodledata
sudo chown www-data:www-data /var/moodledata
sudo chmod 770 /var/moodledata
sudo chown www-data:www-data /var/www/moodle
```

### 7. Configure Nginx
Create `/etc/nginx/sites-available/moodle`:

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    root /var/www/moodle;
    
    client_max_body_size 50M;

    location ~ [^/]\.php(/|$) {
        fastcgi_split_path_info  ^(.+\.php)(/.+)$;
        fastcgi_index            index.php;
        fastcgi_pass             unix:/run/php/php8.3-fpm.sock;
        include                  fastcgi_params;
        fastcgi_param   PATH_INFO       $fastcgi_path_info;
        fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 8. Run Moodle Installation
Buka di browser: `http://yourdomain.com`

Follow installation wizard dan isi:
- Database: MySQL
- Database host: localhost
- Database name: moodle
- Database user: moodleuser
- Database password: (sesuai yang dibuat)
- Moodle data directory: /var/moodledata

---

## 🪟 Instalasi di Windows

### 1. Download XAMPP
- Download dari [apachefriends.org](https://www.apachefriends.org/)
- Install di `C:\xampp`

### 2. Download Moodle
- Download dari [download.moodle.org](https://download.moodle.org/)
- Extract ke `C:\xampp\htdocs\moodle`

### 3. Create Moodle Data Directory
- Create folder `C:\moodledata`
- Set permissions: allow full control

### 4. Create Database
- Start XAMPP
- Open phpMyAdmin: `http://localhost/phpmyadmin`
- Create new database: `moodle`
- Create user: `moodleuser` with password

### 5. Run Installation
- Open `http://localhost/moodle`
- Follow installation wizard

---

## 🐧 Instalasi di CentOS/RHEL

### 1. Install Repository
```bash
sudo yum install -y epel-release
sudo yum install -y remi-release
sudo yum-config-manager --enable remi-php83
```

### 2. Install PHP & Dependencies
```bash
sudo yum install -y \
  php83 php83-php-fpm php83-php-cli \
  php83-php-mysql php83-php-pgsql \
  php83-php-curl php83-php-gd php83-php-zip \
  php83-php-xml php83-php-mbstring \
  php83-php-intl php83-php-soap \
  php83-pecl-sodium \
  nginx \
  mysql-server \
  curl wget git
```

### 3. Start Services
```bash
sudo systemctl start php-fpm
sudo systemctl start nginx
sudo systemctl start mysqld
sudo systemctl enable php-fpm nginx mysqld
```

### 4. Follow steps 4-8 dari instalasi Linux di atas

---

## ☁️ Cloud Deployment

### Heroku
```bash
git remote add heroku https://git.heroku.com/your-moodle-app.git
git push heroku main
heroku config:set MOODLE_URL=https://your-moodle-app.herokuapp.com
```

### AWS EC2
```bash
# Launch Ubuntu 22.04 LTS instance
# Then follow Linux installation steps above
```

### DigitalOcean
```bash
# Create Droplet with Ubuntu 22.04
# SSH ke server dan follow Linux installation steps
```

---

## ✅ Verification Checklist

Setelah instalasi, pastikan:

- [ ] Moodle accessible di browser tanpa error
- [ ] Login dengan admin account berhasil
- [ ] Database connection OK
- [ ] Moodle data directory writable
- [ ] PHP memory limit >= 512MB
- [ ] All required PHP extensions loaded
- [ ] Cron job configured (optional tapi recommended)
- [ ] Backup system configured
- [ ] Email settings configured

---

## 🔧 Post-Installation Configuration

### 1. Configure Cron (Important!)
```bash
# Edit crontab
sudo crontab -e -u www-data

# Add this line (runs every minute)
* * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php > /dev/null
```

### 2. Configure Email
Navigate to: Administration > Server > Email > Outgoing mail server

### 3. Install Theme
Administration > Appearance > Themes

### 4. Install Plugins
Administration > Plugins > Install plugins

---

## 📚 Next Steps

1. Read [README.md](README.md) untuk overview
2. Buat admin account pertama Anda
3. Customize site appearance
4. Create courses
5. Add users
6. Configure plugins

---

## 🆘 Troubleshooting

Lihat [README.md#troubleshooting](README.md#troubleshooting) untuk solusi common issues.

---

**Last Updated:** May 13, 2026
