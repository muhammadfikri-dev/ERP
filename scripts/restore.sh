#!/usr/bin/env bash
# =================================================================
# Script Restore Database SQL ke Frappe Site
# Usage: ./scripts/restore.sh path/to/database.sql.gz
# =================================================================

set -e
source .env 2>/dev/null || true
SITENAME=${SITENAME:-"erp.local"}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-"mariadb_root_secret_password"}

SQL_FILE=$1

if [ -z "$SQL_FILE" ]; then
 echo "\033[0;31m[ERROR] Masukkan path file backup sql.gz! Contoh: ./scripts/restore.sh backups/db.sql.gz\033[0m"
 exit 1
fi

echo -e "\033[0;34m[INFO] Merestore ${SQL_FILE} ke site ${SITENAME}...\033[0m"

docker compose exec -T backend bench --site "${SITENAME}" restore "${SQL_FILE}" \
 --mariadb-root-password "${DB_ROOT_PASSWORD}"

echo -e "\033[0;32m[SUCCESS] Restore selesai!\033[0m"
