#!/usr/bin/env bash
# =================================================================
# Script untuk membuat Site baru dan menginstall ERPNext
# =================================================================

set -e

source .env 2>/dev/null || true

SITENAME=${SITENAME:-"erp.local"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"admin"}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-"mariadb_root_secret_password"}

echo -e "\033[0;34m[INFO] Membuat Frappe Site baru: ${SITENAME}...\033[0m"

docker compose exec -T backend bench new-site "${SITENAME}" \
 --mariadb-root-password "${DB_ROOT_PASSWORD}" \
 --admin-password "${ADMIN_PASSWORD}" \
 --no-mariadb-socket \
 --install-app erpnext \
 --force

echo -e "\033[0;32m[SUCCESS] Site ${SITENAME} berhasil dibuat dengan modul ERPNext!\033[0m"
echo -e "Silakan buka: \033[1;36mhttp://localhost\033[0m atau \033[1;36mhttp://${SITENAME}\033[0m"
echo -e "Username: \033[1;32mAdministrator\033[0m | Password: \033[1;32m${ADMIN_PASSWORD}\033[0m"
