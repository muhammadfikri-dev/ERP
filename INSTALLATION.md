# 📖 Panduan Lengkap Instalasi Frappe & ERPNext v15

Dokumen ini berisi panduan teknis mendalam untuk menginstalasi Frappe Framework dan ERPNext v15 baik menggunakan **Docker Compose** (Metode Rekomendasi) maupun **Bare-Metal Linux (Ubuntu 22.04 / 24.04 LTS)**.

---

## 🚀 Opsi 1: Instalasi Menggunakan Docker (Direkomendasikan)

### Persyaratan Minimum:
- **CPU:** 2 vCPU atau lebih
- **RAM:** Minimum 4 GB (Rekomendasi 8 GB)
- **Disk:** 20 GB SSD
- **OS:** Linux (Ubuntu/Debian/CentOS), macOS, atau Windows WSL2
- **Software:** Docker Engine 24.0+ & Docker Compose v2+

### Langkah-langkah:
1. Pastikan Docker dan Docker Compose telah terpasang:
 ```bash
 docker --version
 docker compose version
 ```
2. Clone repositori:
 ```bash
 git clone https://github.com/muhammadfikri-dev/enterprise-erp.git
 cd enterprise-erp
 ```
3. Konfigurasi `.env`:
 ```bash
 cp .env.example .env
 ```
4. Jalankan container:
 ```bash
 docker compose up -d
 ```
5. Inisialisasi site pertama:
 ```bash
 chmod +x scripts/*.sh
 ./scripts/create-site.sh
 ```

---

## 🖥️ Opsi 2: Instalasi Bare-Metal di Ubuntu 24.04 / 22.04 LTS

Jika Anda ingin menjalankan Frappe Bench secara langsung di server VPS tanpa Docker:

### Langkah 1: Update & Install System Dependencies
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3-dev python3-pip python3-setuptools python3-venv software-properties-common mariadb-server mariadb-client redis-server curl cron xvfb libfontconfig wkhtmltopdf libmysqlclient-dev
```

### Langkah 2: Install Node.js (v18 / v20 LTS) & Yarn
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g yarn
```

### Langkah 3: Konfigurasi MariaDB
Edit file `/etc/mysql/mariadb.conf.d/50-server.cnf` atau buat file `/etc/mysql/conf.d/frappe.cnf`:

```ini
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
```

Restart MariaDB:
```bash
sudo systemctl restart mariadb
sudo mysql_secure_installation
```

### Langkah 4: Buat User Khusus Frappe Bench
```bash
sudo useradd -m -s /bin/bash frappe
sudo usermod -aG sudo frappe
sudo passwd frappe
su - frappe
```

### Langkah 5: Install Frappe Bench CLI
```bash
pip3 install frappe-bench --break-system-packages
bench --version
```

### Langkah 6: Inisialisasi Bench & ERPNext v15
```bash
bench init --frappe-branch version-15 frappe-bench
cd frappe-bench

# Dapatkan aplikasi ERPNext dan HRMS
bench get-app --branch version-15 erpnext
bench get-app --branch version-15 hrms

# Buat site baru
bench new-site erp.local --mariadb-root-password YOUR_ROOT_PASSWORD --admin-password admin

# Install aplikasi ke site
bench --site erp.local install-app erpnext
bench --site erp.local install-app hrms

# Jalankan development server
bench start
```

### Langkah 7: Setup Production Nginx & Supervisor
```bash
sudo bench setup production frappe
```
