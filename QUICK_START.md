# 🚀 Quick Start Guide - Moodle 5.2

Panduan cepat untuk memulai Moodle dalam 5 menit dengan Docker.

## Prasyarat

- Docker installed
- Docker Compose installed
- 2GB RAM free
- 10GB disk space free

**Don't have Docker?** Download dari [docker.com](https://www.docker.com/products/docker-desktop)

---

## ⚡ Start dalam 5 Langkah

### 1️⃣ Clone Repository
```bash
git clone https://github.com/kafazaku/moodleku.git
cd moodleku
```

### 2️⃣ Setup Environment
```bash
cp .env.example .env
```

### 3️⃣ Edit Konfigurasi (Optional)
```bash
nano .env
```

**Default values sudah OK untuk development!**

| Setting | Default | Ubah jika |
|---------|---------|-----------|
| MOODLE_URL | http://localhost | Pakai domain sendiri |
| ADMIN_USER | admin | Pakai username lain |
| ADMIN_PASSWORD | password123 | HARUS diganti di production! |
| DB_PASSWORD | moodle | HARUS diganti di production! |

### 4️⃣ Start Services
```bash
docker-compose up -d
```

**Tunggu 30-60 detik untuk services siap...**

### 5️⃣ Buka Moodle
```bash
# Di browser buka:
http://localhost

# Atau jika pakai custom domain:
http://yourdomain.com
```

---

## 🔑 Login Pertama

**Username:** `admin` (atau custom username Anda)  
**Password:** `password123` (atau custom password Anda)

> ⚠️ **Segera ubah password!**
> Setelah login, pergi ke: Profile → Change Password

---

## 📱 Akses Dari Device Lain

### Dari Laptop/Desktop di Network Sama
```
http://server-ip-address
```

Cari IP address dengan:
```bash
# macOS/Linux
ifconfig

# Windows
ipconfig

# Docker
docker-compose ps
```

### Dari Internet (Public Domain)
1. Point domain ke server IP
2. Update `MOODLE_URL` di `.env`
3. Restart containers: `docker-compose restart`
4. Setup SSL untuk HTTPS

---

## ✅ Verify Installation

Pastikan semua services berjalan:

```bash
docker-compose ps
```

Output harus:
```
NAME                   STATUS
moodle-app            Up (healthy)
moodle-mysql          Up (healthy)
moodle-nginx          Up
```

Check logs jika ada yang bermasalah:
```bash
docker-compose logs moodle
```

---

## 🎓 First Steps di Moodle

Setelah login, lakukan:

### 1. Customize Site
- **Admin Dashboard** → Site Settings
- Set: Site Name, Description, Logo

### 2. Create First Course
- **Dashboard** → Create Course
- Isi: Course Name, Code, Description
- Klik Save

### 3. Add Content
- Klik course Anda
- **Turn editing on** (tombol top-right)
- Tambah: Lectures, Assignments, Quizzes
- Klik Save

### 4. Add Users
- **Admin Dashboard** → Users
- **Enroll Students** to courses

### 5. Test Course
- Logout sebagai admin
- Login sebagai student
- Akses course
- Submit assignment, etc

---

## 🔧 Useful Commands

```bash
# View logs
docker-compose logs -f moodle

# Stop services
docker-compose down

# Restart service
docker-compose restart moodle

# SSH into container
docker-compose exec moodle bash

# View database
docker-compose exec moodle-db mysql -u moodle -pmoodle moodle

# Backup database
docker-compose exec moodle-db mysqldump -u moodle -pmoodle moodle > backup.sql

# Restore database
docker-compose exec -T moodle-db mysql -u moodle -pmoodle moodle < backup.sql
```

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `.env` | Configuration (passwords, domains, etc) |
| `docker-compose.yml` | Docker services definition |
| `config.php` | Moodle configuration |
| `nginx.conf` | Web server settings |
| `mysql.cnf` | Database settings |

---

## 🛡️ Security Checklist

- [ ] Change admin password
- [ ] Set `MOODLE_URL` to real domain
- [ ] Change `DB_PASSWORD` in `.env`
- [ ] Change `ADMIN_PASSWORD` in `.env`
- [ ] Configure SMTP for emails
- [ ] Enable SSL/HTTPS
- [ ] Setup regular backups
- [ ] Configure cron jobs

---

## ⚠️ Common Issues

### "Connection refused"
**Solution:** Wait 60 seconds, services take time to start
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs moodle
```

### "Admin login tidak bekerja"
**Solution:** Check .env file
```bash
# Verify credentials in .env
cat .env | grep ADMIN
```

### "Cannot access from other devices"
**Solution:** Update `MOODLE_URL`
```bash
# Edit .env
nano .env

# Change:
# MOODLE_URL=http://your-device-ip
# or
# MOODLE_URL=http://your-domain.com

# Restart
docker-compose restart
```

### "Disk space penuh"
**Solution:** Clean up Docker
```bash
# Remove unused images/containers
docker system prune -a

# Check space
docker system df
```

---

## 📚 Learn More

- [Installation Guide](INSTALLATION.md) - Detailed setup instructions
- [Deployment Guide](DEPLOYMENT.md) - Production deployment
- [Official Moodle Docs](https://docs.moodle.org/) - Complete documentation
- [README.md](README.md) - Overview & troubleshooting

---

## 🆘 Still Having Issues?

1. Check Docker logs:
   ```bash
   docker-compose logs
   ```

2. Create GitHub Issue:
   [Create Issue](https://github.com/kafazaku/moodleku/issues)

3. Check Official Docs:
   [docs.moodle.org](https://docs.moodle.org/)

---

**🎉 Congratulations! Moodle is running!**

Next: Create courses, add students, and start teaching! 📚

---

**Need help?** The community is helpful and responsive at [moodle.org](https://moodle.org/)
