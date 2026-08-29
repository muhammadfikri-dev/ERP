#!/usr/bin/env bash
# =================================================================
# Script Backup Database & File Aset Frappe Site
# =================================================================

set -e
source .env 2>/dev/null || true
SITENAME=${SITENAME:-"erp.local"}

BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

echo -e "\033[0;34m[INFO] Memulai backup untuk site: ${SITENAME}...\033[0m"

docker compose exec -T backend bench --site "${SITENAME}" backup --with-files

echo -e "\033[0;32m[SUCCESS] Backup selesai! File backup tersimpan di volume sites.\033[0m"
