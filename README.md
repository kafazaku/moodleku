# Moodle Deployment Guide

Dokumentasi lengkap untuk deployment Moodle versi terbaru (5.2) untuk akun kafazaku.

## 📋 Daftar Isi
1. [Persyaratan Sistem](#persyaratan-sistem)
2. [Instalasi dengan Docker](#instalasi-dengan-docker)
3. [Instalasi Manual](#instalasi-manual)
4. [Konfigurasi Database](#konfigurasi-database)
5. [Setup Awal](#setup-awal)
6. [Troubleshooting](#troubleshooting)

---

## Persyaratan Sistem

### Moodle 5.2 Requirements:
- **PHP:** 8.3.0+ (64-bit only)
- **Database:** PostgreSQL 16, MySQL 8.4, MariaDB 10.11.0, atau MySQL Aurora 8.0
- **Web Server:** Apache 2.4+, Nginx 1.18+
- **Memory:** Minimum 512MB RAM (1GB+ recommended)
- **Disk Space:** Minimum 200MB untuk Moodle core + content
- **PHP Extensions:** sodium, curl, gd, zip, xml, mbstring, fileinfo

---

## Instalasi dengan Docker

### Langkah 1: Clone Repository
```bash
git clone https://github.com/kafazaku/moodleku.git
cd moodleku
```

### Langkah 2: Setup Environment Variables
```bash
cp .env.example .env
```

Edit `.env` dengan konfigurasi Anda:
```
MOODLE_VERSION=5.2
DB_TYPE=mysql
DB_HOST=moodle-db
DB_NAME=moodle
DB_USER=moodle
DB_PASSWORD=your_secure_password
MOODLE_URL=http://localhost
ADMIN_USER=admin
ADMIN_PASSWORD=your_secure_password
```

### Langkah 3: Start Services
```bash
docker-compose up -d
```

### Langkah 4: Install Moodle
```bash
docker-compose exec moodle php install.php --lang=en
```

Akses Moodle di: `http://localhost`

---

## Instalasi Manual

### Langkah 1: Download Moodle 5.2
```bash
cd /var/www
wget https://download.moodle.org/download.php/direct/stable42/moodle-5.2.tgz
tar -xzf moodle-5.2.tgz
```

### Langkah 2: Create Moodle Data Directory
```bash
mkdir -p /var/moodledata
chmod 777 /var/moodledata
chown www-data:www-data /var/moodledata
chown www-data:www-data /var/www/moodle
```

### Langkah 3: Setup Database
Lihat bagian [Konfigurasi Database](#konfigurasi-database)

### Langkah 4: Configure Web Server
Lihat file `nginx.conf` atau `apache.conf` dalam repository ini

### Langkah 5: Access Installation Wizard
Buka di browser: `http://your-domain/moodle`

---

## Konfigurasi Database

### MySQL/MariaDB
```sql
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
```

### PostgreSQL
```sql
CREATE DATABASE moodle WITH ENCODING 'UTF8';
CREATE USER moodleuser WITH PASSWORD 'password123';
ALTER DATABASE moodle OWNER TO moodleuser;
GRANT ALL PRIVILEGES ON DATABASE moodle TO moodleuser;
```

---

## Setup Awal

Setelah instalasi berhasil:

1. **Login dengan admin account** yang telah dibuat saat instalasi
2. **Konfigurasi Site Settings**: 
   - Site name
   - Site description
   - Front page settings
3. **Setup User Account**: Buat akun pengguna Anda
4. **Create Courses**: Mulai buat kursus
5. **Configure Plugins**: Install/manage plugins sesuai kebutuhan

---

## Troubleshooting

### Error: "moodledata directory is not writable"
```bash
chmod 777 /var/moodledata
chown www-data:www-data /var/moodledata
```

### Error: "PHP Extension tidak ditemukan"
Instal extension yang diperlukan:
```bash
# Ubuntu/Debian
sudo apt-get install php8.3-sodium php8.3-curl php8.3-gd php8.3-zip

# CentOS/RHEL
sudo yum install php83-pecl-sodium php83-curl php83-gd php83-zip
```

### Database Connection Error
- Pastikan database service berjalan
- Verify username, password, dan hostname
- Check firewall rules untuk database port

### Slow Performance
- Increase PHP memory_limit ke 512MB atau lebih
- Enable opcode caching (OPcache)
- Configure Moodle cron properly

---

## Dokumentasi Lengkap

Untuk dokumentasi lebih detail, lihat:
- [Official Moodle Docs](https://docs.moodle.org/)
- [Moodle 5.2 Release Notes](https://moodledev.io/general/releases/5.2)
- File dokumentasi lainnya dalam repository ini

---

## Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini atau hubungi Moodle community.

**Last Updated:** May 13, 2026
**Maintained by:** kafazaku
