#!/bin/bash

################################################################################
# GLPI Database and Files Backup Script
# Backs up GLPI database and files with compression and verification
# Safe to run as cron job or manually
################################################################################

set -e

# Configuration
GLPI_PATH="/var/www/glpi"
GLPI_DB="glpi"
BACKUP_DIR="/mnt/backups/glpi-global"
LOG_FILE="/var/log/glpi-backup/backup.log"
RETENTION_DAYS=90
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="glpi_backup_${TIMESTAMP}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

# Ensure log directory exists
mkdir -p $(dirname "$LOG_FILE")

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" | tee -a "$LOG_FILE"
}

log "=========================================="
log "GLPI Backup Started"
log "=========================================="

# Check if GLPI path exists
if [ ! -d "$GLPI_PATH" ]; then
    log "ERROR: GLPI path not found: $GLPI_PATH"
    exit 1
fi

# Create temporary directory for backup
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log "Using temporary directory: $TEMP_DIR"

# Backup GLPI Database
log "Backing up MariaDB database: $GLPI_DB"
mysqldump --single-transaction --routines --triggers \
    "$GLPI_DB" > "$TEMP_DIR/glpi_database.sql"

if [ $? -ne 0 ]; then
    log "ERROR: Database backup failed"
    exit 1
fi

DB_SIZE=$(du -h "$TEMP_DIR/glpi_database.sql" | cut -f1)
log "✓ Database backed up: $DB_SIZE"

# Backup GLPI Files
log "Backing up GLPI files and configuration"
tar --exclude='./vendor' --exclude='./.git' \
    -cf "$TEMP_DIR/glpi_files.tar" \
    -C "$(dirname $GLPI_PATH)" "$(basename $GLPI_PATH)"

if [ $? -ne 0 ]; then
    log "ERROR: Files backup failed"
    exit 1
fi

FILES_SIZE=$(du -h "$TEMP_DIR/glpi_files.tar" | cut -f1)
log "✓ Files backed up: $FILES_SIZE"

# Compress everything
log "Compressing backup..."
mkdir -p "$BACKUP_DIR"
cd "$TEMP_DIR"
tar -czf "$BACKUP_PATH.tar.gz" glpi_database.sql glpi_files.tar

if [ $? -ne 0 ]; then
    log "ERROR: Compression failed"
    exit 1
fi

FINAL_SIZE=$(du -h "$BACKUP_PATH.tar.gz" | cut -f1)
log "✓ Backup compressed: $FINAL_SIZE"

# Verify backup integrity
log "Verifying backup integrity..."
if tar -tzf "$BACKUP_PATH.tar.gz" > /dev/null 2>&1; then
    log "✓ Backup integrity verified"
else
    log "ERROR: Backup integrity check failed"
    rm -f "$BACKUP_PATH.tar.gz"
    exit 1
fi

# Create backup manifest
cat > "$BACKUP_PATH.manifest" << MANIFEST
Backup Date: $(date)
GLPI Path: $GLPI_PATH
Database: $GLPI_DB
Database Size: $DB_SIZE
Files Size: $FILES_SIZE
Compressed Size: $FINAL_SIZE
Retention: $RETENTION_DAYS days
Backup File: $BACKUP_PATH.tar.gz

Contents:
- glpi_database.sql (MariaDB dump)
- glpi_files.tar (GLPI files and config)
MANIFEST

log "✓ Backup manifest created"

# Clean old backups (keep last 90 days)
log "Cleaning old backups (keeping $RETENTION_DAYS days)..."
find "$BACKUP_DIR" -maxdepth 1 -name "glpi_backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
CLEANED=$(find "$BACKUP_DIR" -maxdepth 1 -name "glpi_backup_*.tar.gz" | wc -l)
log "✓ Backups retained: $CLEANED"

log "=========================================="
log "✓ GLPI Backup Completed Successfully"
log "Location: $BACKUP_PATH.tar.gz"
log "=========================================="
