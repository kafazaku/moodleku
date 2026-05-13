# Deployment Guide untuk Moodle 5.2

Panduan lengkap untuk deploy Moodle ke berbagai platform hosting.

## 📋 Daftar Platform Deployment

1. [Docker](#docker-deployment)
2. [Heroku](#heroku-deployment)
3. [AWS](#aws-deployment)
4. [DigitalOcean](#digitalocean-deployment)
5. [Linode](#linode-deployment)
6. [Shared Hosting](#shared-hosting)

---

## 🐳 Docker Deployment

### Prerequisites
- Docker installed ([docker.com](https://docs.docker.com/get-docker/))
- Docker Compose installed
- Git installed

### Deployment Steps

```bash
# 1. Clone repository
git clone https://github.com/kafazaku/moodleku.git
cd moodleku

# 2. Setup environment
cp .env.example .env

# 3. Edit configuration
nano .env
# Update:
# - MOODLE_URL
# - DB credentials
# - Admin credentials
# - SMTP settings (optional)

# 4. Build and start containers
docker-compose build
docker-compose up -d

# 5. Check logs
docker-compose logs -f moodle

# 6. Access Moodle
# Open: http://localhost (or your MOODLE_URL)
```

### Docker Commands
```bash
# Stop containers
docker-compose down

# View logs
docker-compose logs moodle

# Restart service
docker-compose restart moodle

# Update and restart
git pull
docker-compose up -d --build

# Backup database
docker-compose exec moodle-db mysqldump -u moodle -ppassword moodle > backup.sql

# Restore database
docker-compose exec -T moodle-db mysql -u moodle -ppassword moodle < backup.sql
```

---

## ☁️ Heroku Deployment

### Prerequisites
- Heroku account ([heroku.com](https://www.heroku.com))
- Heroku CLI installed

### Deployment Steps

```bash
# 1. Login to Heroku
heroku login

# 2. Create Heroku app
heroku create your-moodle-app

# 3. Add Procfile (already included)
# Deploy dengan: git push heroku main

# 4. Add MySQL add-on
heroku addons:create cleardb:ignite

# 5. Set environment variables
heroku config:set \
  MOODLE_URL=https://your-moodle-app.herokuapp.com \
  ADMIN_USER=admin \
  ADMIN_PASSWORD=your_secure_password

# 6. Deploy
git push heroku main

# 7. Initialize database
heroku run php install.php --lang=en

# 8. View logs
heroku logs --tail
```

### Heroku Limitations
- Ephemeral filesystem (files deleted on dyno restart)
- File uploads tidak persistent
- Solusi: Gunakan S3 atau cloud storage lainnya

---

## 🏗️ AWS Deployment

### Option 1: EC2 + RDS

#### Launch EC2 Instance
```bash
# 1. Launch Ubuntu 22.04 LTS instance
# - Instance type: t3.medium (minimum)
# - Storage: 50GB
# - Security group: Allow HTTP (80), HTTPS (443), SSH (22)

# 2. SSH ke instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# 3. Install dependencies (Ubuntu)
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
  php8.3 php8.3-fpm php8.3-cli \
  php8.3-mysql php8.3-curl php8.3-gd \
  php8.3-zip php8.3-xml php8.3-mbstring \
  php8.3-intl php8.3-soap php8.3-pecl-sodium \
  nginx curl wget git

# 4. Clone repository
cd /var/www
sudo git clone https://github.com/kafazaku/moodleku.git moodle
cd moodle
```

#### Setup RDS Database
```bash
# 1. Create RDS MySQL instance
# - Engine: MySQL 8.4
# - Instance class: db.t3.micro (minimum)
# - Storage: 100GB gp3
# - Enable backups

# 2. Get RDS endpoint (example: moodle-db.abc123.us-east-1.rds.amazonaws.com)

# 3. Update .env dengan RDS endpoint
# DB_HOST=moodle-db.abc123.us-east-1.rds.amazonaws.com
```

#### Continue Setup
```bash
# 5. Configure Nginx
sudo cp nginx.conf /etc/nginx/sites-available/moodle
sudo ln -s /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# 6. Setup SSL (Let's Encrypt)
sudo apt-get install certbot python3-certbot-nginx
sudo certbot certonly --nginx -d yourdomain.com

# 7. Create moodledata directory
sudo mkdir -p /var/moodledata
sudo chown www-data:www-data /var/moodledata

# 8. Run Moodle installer
# Open: https://yourdomain.com
```

#### Use S3 for File Storage
```php
// Add ke config.php
$CFG->filelib_aws_key = 'your-aws-key';
$CFG->filelib_aws_secret = 'your-aws-secret';
$CFG->filelib_aws_region = 'us-east-1';
$CFG->filelib_aws_bucket = 'moodle-files';
$CFG->filelib_aws_serverside_encryption = true;
```

---

## 🔧 DigitalOcean Deployment

### Option 1: Droplets

```bash
# 1. Create Droplet
# - OS: Ubuntu 22.04 x64
# - Size: $12/month (4GB RAM, 80GB SSD)
# - Region: Choose nearest

# 2. SSH to Droplet
ssh root@your-droplet-ip

# 3. Initial Setup
apt-get update
apt-get upgrade -y
apt-get install -y curl wget git

# 4. Follow AWS EC2 installation steps (same as above)
```

### Option 2: App Platform (Easier)

```bash
# 1. Create App on DigitalOcean App Platform
# - Connect GitHub repo: kafazaku/moodleku
# - Choose Dockerfile deployment

# 2. Configure environment variables in App Platform:
# MOODLE_URL=https://your-app.ondigitalocean.app
# DB_TYPE=mysql
# (etc.)

# 3. Create database component
# - Engine: MySQL 8.4
# - Size: Starter

# 4. Deploy from GitHub
# Automatic deployment on push
```

---

## 💾 Linode Deployment

```bash
# 1. Create Linode
# - Image: Ubuntu 22.04 LTS
# - Region: Choose nearest
# - Size: Linode 4GB ($20/month)

# 2. Boot and SSH
ssh root@your-linode-ip

# 3. Update system
apt-get update && apt-get upgrade -y

# 4. Follow same steps as DigitalOcean/AWS
```

---

## 🌐 Shared Hosting Deployment

For cPanel/Plesk hosting:

```bash
# 1. Upload Moodle files via FTP
# - Upload to public_html directory
# - Extract .tar.gz file

# 2. Create MySQL database via cPanel
# - Database name: moodle
# - User: moodle
# - Password: (generate secure one)

# 3. Create moodledata directory
# - Create outside public_html
# - Set permissions to 755

# 4. Create config.php manually
# - Use template from config.php in this repo
# - Update database credentials

# 5. Run installer
# - Open: http://yourdomain.com/moodle
# - Follow wizard

# Limitations:
# - May have memory limits
# - May not support all PHP extensions
# - Limited customization
```

---

## 🔐 SSL/TLS Configuration

### Let's Encrypt (Free)
```bash
# Ubuntu/Debian
sudo apt-get install certbot python3-certbot-nginx
sudo certbot certonly --nginx -d yourdomain.com
sudo certbot renew --dry-run  # Test renewal
```

### Update Nginx
```nginx
listen 443 ssl http2;
ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
```

### Auto Renewal Cron
```bash
sudo crontab -e
# Add: 0 2 * * * certbot renew --quiet
```

---

## 📊 Monitoring & Maintenance

### Monitor Server Health
```bash
# CPU & Memory
top
free -h
df -h

# Logs
tail -f /var/log/nginx/error.log
tail -f /var/log/php-fpm.log
tail -f /var/log/mysql/error.log
```

### Backup Strategy
```bash
#!/bin/bash
# backup.sh

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup database
mysqldump -u moodle -p$DB_PASSWORD moodle | gzip > $BACKUP_DIR/moodle_db_$DATE.sql.gz

# Backup moodledata
tar -czf $BACKUP_DIR/moodledata_$DATE.tar.gz /var/moodledata

# Upload to S3 (optional)
aws s3 cp $BACKUP_DIR/moodle_db_$DATE.sql.gz s3://your-bucket/backups/

# Keep only last 30 days
find $BACKUP_DIR -type f -mtime +30 -delete
```

Schedule with cron:
```bash
# Run daily at 2 AM
0 2 * * * /bin/bash /home/ubuntu/backup.sh
```

---

## 🚀 Performance Optimization

### Enable Caching
```php
// config.php
$CFG->cachestore_file_path_cache = $CFG->cachedir;
$CFG->cachejs = true;
$CFG->cachetext = true;
```

### Database Optimization
```bash
# Run MySQL optimization
mysql -u root -p moodle < optimize.sql
```

### Increase PHP Limits
```ini
; /etc/php/8.3/fpm/php.ini
memory_limit = 512M
upload_max_filesize = 50M
post_max_size = 50M
max_execution_time = 300
max_input_vars = 5000
```

---

## 🔄 Updating Moodle

```bash
# 1. Backup everything
./backup.sh

# 2. Put in maintenance mode
# Admin > Site admin > Server > Maintenance mode

# 3. Update code
git pull origin main

# 4. Run upgrade
php admin/cli/upgrade.php

# 5. Test and turn off maintenance mode
```

---

## 📱 Domain Setup

### Point Domain to Server

#### For EC2/DigitalOcean/Linode:
```
DNS Records:
A     yourdomain.com       -> your-server-ip
CNAME www.yourdomain.com   -> yourdomain.com
```

#### For Heroku:
```
CNAME yourdomain.com -> your-app-name.herokuapp.com
```

#### For App Platform:
```
CNAME yourdomain.com -> your-app.ondigitalocean.app
```

---

## ✅ Post-Deployment Checklist

- [ ] Moodle accessible via domain
- [ ] SSL certificate valid
- [ ] Database connection working
- [ ] Email sending configured
- [ ] Cron jobs configured
- [ ] Backup system in place
- [ ] File permissions correct
- [ ] Performance optimizations done
- [ ] Monitoring set up
- [ ] Admin account created
- [ ] Default courses created
- [ ] Plugins installed/configured

---

## 🆘 Common Issues

### "Moodle directory is not writable"
```bash
sudo chown -R www-data:www-data /var/www/moodle
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 755 /var/www/moodle
sudo chmod -R 777 /var/moodledata
```

### Database Connection Failed
- Check credentials in config.php
- Verify database is running
- Check firewall rules
- Verify database user has correct permissions

### Slow Performance
- Enable OPcache
- Increase PHP memory_limit
- Optimize database indexes
- Enable Moodle caching
- Use CDN for static files

---

**Last Updated:** May 13, 2026
