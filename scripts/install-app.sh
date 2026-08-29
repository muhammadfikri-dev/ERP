#!/usr/bin/env bash
# =================================================================
# Script Instalasi Aplikasi Frappe Tambahan (misal: hrms, payments, dll)
# Usage: ./scripts/install-app.sh hrms
# =================================================================

set -e
source .env 2>/dev/null || true
SITENAME=${SITENAME:-"erp.local"}

APP_NAME=$1

if [ -z "$APP_NAME" ]; then
 echo "Usage: ./scripts/install-app.sh <app_name> (e.g., hrms, payments, custom_core)"
 exit 1
fi

echo -e "\033[0;34m[INFO] Menginstall aplikasi ${APP_NAME} ke site ${SITENAME}...\033[0m"

docker compose exec -T backend bench --site "${SITENAME}" install-app "${APP_NAME}"

echo -e "\033[0;32m[SUCCESS] Aplikasi ${APP_NAME} berhasil dipasang di ${SITENAME}!\033[0m"
