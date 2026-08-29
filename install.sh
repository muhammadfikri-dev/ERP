#!/usr/bin/env bash
# =================================================================
# Enterprise ERPNext Installer
# Interactive & Automated Installation Script
# =================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN} 🚀 Enterprise Frappe & ERPNext v15 Installer ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
 echo -e "${RED}[ERROR] Docker tidak ditemukan! Silakan install Docker terlebih dahulu.${NC}"
 exit 1
fi

# Check Docker Compose
if ! docker compose version &> /dev/null; then
 echo -e "${RED}[ERROR] Docker Compose v2 tidak ditemukan!${NC}"
 exit 1
fi

echo -e "${GREEN}[OK] Docker & Docker Compose terdeteksi.${NC}"

# Setup .env if not exists
if [ ! -f .env ]; then
 echo -e "${YELLOW}[INFO] Menyiapkan file konfigurasi .env dari .env.example...${NC}"
 cp .env.example .env
fi

# Make scripts executable
chmod +x scripts/*.sh

echo -e "${YELLOW}Menjalankan container stack menggunakan Docker Compose...${NC}"
docker compose up -d

echo -e "${YELLOW}Menunggu database MariaDB sehat dan siap...${NC}"
docker compose exec -T mariadb mysqladmin ping -h localhost -u root -p$(grep DB_ROOT_PASSWORD .env | cut -d '=' -f2) --silent --wait=60

echo -e "${GREEN}[OK] Seluruh container berjalan.${NC}"
echo ""
echo -e "${BLUE}Ingin langsung membuat Site baru sekarang? (Y/n)${NC}"
read -r response
response=${response:-Y}

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
 ./scripts/create-site.sh
else
 echo -e "${YELLOW}Anda dapat membuat site kapan saja dengan menjalankan: ./scripts/create-site.sh${NC}"
fi

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN} Instalasi Selesai! Selamat menggunakan Enterprise ERP!${NC}"
echo -e "${GREEN}====================================================${NC}"
