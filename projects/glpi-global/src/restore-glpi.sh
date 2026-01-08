#!/bin/bash

################################################################################
# GLPI Restore Script
# Restores GLPI database and files from backup
# Use with caution - will overwrite current data!
################################################################################

set -e

BACKUP_FILE="$1"
GLPI_PATH="/var/www/glpi"
GLPI_DB="glpi"
LOG_FILE="/var/log/glpi-backup/restore.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" | tee -a "$LOG_FILE"
}

# Validate input
if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "Usage: $0 /path/to/backup/glpi_backup_YYYYMMDD_HHMMSS.tar.gz"
    echo ""
    echo "Available backups:"
    ls -lh /mnt/backups/glpi-global/glpi_backup_*.tar.gz 2>/dev/null || echo "No backups found"
    exit 1
fi

log "=========================================="
log "GLPI Restore Started"
log "=========================================="
log "Backup file: $BACKUP_FILE"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log "Extracting backup..."
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"

if [ ! -f "$TEMP_DIR/glpi_database.sql" ]; then
    log "ERROR: Database backup not found in archive"
    exit 1
fi

# Confirmation
echo "=========================================="
echo "RESTORE WARNING"
echo "=========================================="
echo "This will:"
echo "  - Drop the current '$GLPI_DB' database"
echo "  - Restore from backup: $BACKUP_FILE"
echo "  - Restore GLPI files"
echo ""
read -p "Continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    log "Restore cancelled"
    exit 0
fi

# Stop GLPI services if running
log "Stopping GLPI services..."
systemctl stop apache2 2>/dev/null || true

# Drop and restore database
log "Restoring database..."
mysql -e "DROP DATABASE IF EXISTS $GLPI_DB;"
mysql -e "CREATE DATABASE $GLPI_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql "$GLPI_DB" < "$TEMP_DIR/glpi_database.sql"

if [ $? -ne 0 ]; then
    log "ERROR: Database restore failed"
    exit 1
fi

log "✓ Database restored"

# Restore files
log "Restoring GLPI files..."
mkdir -p "$GLPI_PATH"
tar -xf "$TEMP_DIR/glpi_files.tar" -C "$(dirname $GLPI_PATH)"

if [ $? -ne 0 ]; then
    log "ERROR: Files restore failed"
    exit 1
fi

log "✓ Files restored"

# Fix permissions
log "Fixing permissions..."
chown -R www-data:www-data "$GLPI_PATH"

# Restart services
log "Restarting GLPI services..."
systemctl start apache2 2>/dev/null || true

log "=========================================="
log "✓ GLPI Restore Completed"
log "=========================================="
log "Access GLPI at: http://10.0.3.13"
