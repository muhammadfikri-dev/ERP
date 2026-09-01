# 🚀 Enterprise ERP (Frappe & ERPNext v15 - Ready to Install)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Frappe Framework](https://img.shields.io/badge/Frappe-v15.x%20LTS-blue.svg)](https://frappeframework.com/)
[![ERPNext](https://img.shields.io/badge/ERPNext-v15.x%20LTS-green.svg)](https://erpnext.com/)
[![Docker Ready](https://img.shields.io/badge/Docker-Compose%20Ready-2496ED.svg?logo=docker&logoColor=white)](#)
[![Developer: Muhammad Fikri](https://img.shields.io/badge/Developer-Muhammad%20Fikri-blue.svg)](#)

A fully configured, production-ready, and turnkey deployment repository for **Frappe Framework & ERPNext v15**. This repository contains automated installer scripts, multi-container Docker Compose architectures, Nginx reverse proxy configurations, MariaDB optimizations, database backup utilities, and a custom **Custom Core** extension app skeleton.

---

## 📑 Daftar Isi
- [Fitur Utama](#-fitur-utama)
- [Arsitektur Sistem](#-arsitektur-sistem)
- [Instalasi Cepat (Quick Start - Docker)](#-instalasi-cepat-quick-start-docker)
- [Instalasi Otomatis (Interactive Installer Script)](#-instalasi-otomatis-interactive-installer-script)
- [Instalasi Bare-Metal (Bench / Ubuntu)](#-instalasi-bare-metal-bench--ubuntu)
- [Struktur Direktori](#-struktur-direktori)
- [Manajemen & Operasional](#-manajemen--operasional)
- [Modul & Ekstensi Muhammad Fikri](#-modul--ekstensi-Muhammad Fikri)
- [Lisensi](#-lisensi)

---

## ✨ Fitur Utama

- 🐳 **One-Command Docker Compose:** Menjalankan seluruh stack ERPNext (Frontend, Backend Gunicorn, WebSocket, Background Worker Queues, Scheduler, MariaDB, dan 3x Redis instances).
- ⚡ **Auto-Provisioning Site Script:** Skrip otomatis untuk inisialisasi site baru, migrasi database MariaDB, dan instalasi aplikasi (ERPNext, HRMS, Payments, dll).
- 🛡️ **MariaDB Barcode & Unicode Optimized:** Konfigurasi `my.cnf` sudah disetel dengan `character-set-server = utf8mb4`, `innodb_buffer_pool_size`, dan `max_allowed_packet` sesuai rekomendasi resmi Frappe.
- 🔄 **Automated Backup & Restore:** Utilitas backup otomatis harian ke direktori lokal / S3 storage.
- 📦 **Custom App Skeleton Included:** Sudah dilengkapi starter app `custom_core` untuk kustomisasi DocType, hooks, dan logika bisnis perusahaan.
- 🌐 **Nginx Reverse Proxy & SSL Ready:** Konfigurasi Nginx siap pakai dengan dukungan SSL Let's Encrypt / Certbot.

---

## 🏗️ Arsitektur Sistem

```
 [ Client / Browser ]
 │
 HTTP/HTTPS (Port 80/443)
 ▼
 [ Nginx / Frontend ]
 │
 ┌───────────────────────┴───────────────────────┐
 │ (HTTP API / Static) │ (WebSocket)
 ▼ ▼
 [ Backend (Gunicorn) ] [ Frappe Socket.io ]
 │ │
 ├───────────────────────┬───────────────────────┤
 ▼ ▼ ▼
 [ MariaDB 10.6+ ] [ Redis Cache ] [ Redis SocketIO ]
 ▲ ▲
 │ │
 [ Background Workers ] [ Redis Queue ]
 (Default, Short, Long)
```

---

## ⚡ Instalasi Cepat (Quick Start - Docker)

### 1. Clone Repositori
```bash
git clone https://github.com/muhammadfikri-dev/enterprise-erp.git
cd enterprise-erp
```

### 2. Salin Konfigurasi Environment
```bash
cp .env.example .env
```
*(Buka file `.env` untuk menyesuaikan domain, password MariaDB, dan password Administrator Frappe jika diperlukan)*.

### 3. Jalankan Stack Menggunakan Docker Compose
```bash
docker compose up -d
```

### 4. Inisialisasi Site & ERPNext Pertama Kali
Jalankan skrip inisialisasi otomatis:
```bash
chmod +x scripts/*.sh
./scripts/create-site.sh
```

Akses sistem di browser Anda: **`http://localhost`** atau **`http://erp.local`**
- **User:** `Administrator`
- **Password:** *Sesuai `ADMIN_PASSWORD` di file `.env` (default: `admin`)*

---

## 🛠️ Instalasi Otomatis (Interactive Installer Script)

Kami telah menyediakan skrip instalasi interaktif yang akan memeriksa dependencies (Docker, Docker Compose, curl, git), membuat konfigurasi, dan menjalankan sistem secara otomatis:

```bash
chmod +x install.sh
./install.sh
```

---

## 💻 Instalasi Bare-Metal (Bench / Ubuntu)

Jika Anda ingin menginstal Frappe & ERPNext langsung pada sistem Ubuntu 22.04 / 24.04 tanpa Docker:

Panduan lengkap langkah demi langkah mulai dari instalasi Python 3.11/3.12, Node.js, MariaDB, Redis, Frappe Bench, hingga Nginx Production Setup tersedia di:
👉 **[Lihat Dokumentasi Lengkap: INSTALLATION.md](./INSTALLATION.md)**

---

## 📁 Struktur Direktori

```
enterprise-erp/
├── .env.example # Template variabel environment
├── docker-compose.yml # Konfigurasi multi-container production stack
├── docker-compose.dev.yml # Konfigurasi single-container development stack
├── install.sh # Skrip instalasi interaktif 1-klik
├── INSTALLATION.md # Dokumentasi detail instalasi bare-metal & container
├── configs/
│ ├── mariadb.cnf # Konfigurasi teroptimasi MariaDB untuk Frappe
│ └── nginx.conf # Konfigurasi Reverse Proxy Nginx & WebSockets
├── scripts/
│ ├── create-site.sh # Inisialisasi site baru & instalasi modul ERPNext
│ ├── backup.sh # Skrip backup database & file aset
│ ├── restore.sh # Skrip restore database dari file sql.gz
│ └── install-app.sh # Skrip instalasi aplikasi Frappe baru
├── apps/
│ └── custom_core/ # Starter Custom Frappe App untuk Muhammad Fikri
└── README.md
```

---

## 🔧 Manajemen & Operasional

### 1. Membuat Backup Database
```bash
./scripts/backup.sh
```
*File backup akan disimpan di direktori `./backups/` dalam format `.sql.gz` dan `.tar`*.

### 2. Memeriksa Log Container
```bash
# Melihat seluruh log
docker compose logs -f

# Melihat log backend Frappe
docker compose logs -f backend
```

### 3. Restart Layanan
```bash
docker compose restart
```

### 4. Mematikan Layanan
```bash
docker compose down
```

---

## 🧩 Modul & Ekstensi Custom

Aplikasi bawaan **`custom_core`** terletak di dalam folder `apps/custom_core/`. Modul ini siap digunakan untuk:
- Custom DocTypes & Business Logic khusus perusahaan.
- Custom Print Formats (Invoice, Surat Jalan, Purchase Order).
- Integrasi IoT (ESP32/Arduino data feed langsung ke database ERPNext via REST API / Webhooks).
- Custom Theme & Branding Login Page.

---

## 📄 Lisensi

Proyek ini didistribusikan di bawah lisensi open-source **MIT License**.
Dikembangkan & Dikelola oleh **Muhammad Fikri**.

---

<p align="center">
  Dibuat dengan ❤️ oleh <b>Muhammad Fikri Dev</b>
</p>
