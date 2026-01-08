# GLPI Backup & Recovery Procedures

## Current Setup

**GLPI Server:** 10.0.3.13
**Backup Location:** /mnt/backups/glpi-global/ (on 10.0.3.13)
**Retention:** 90 days
**Database Size:** ~130MB
**Files Size:** ~380MB
**Compressed:** ~100MB

## Scripts

- `backup-glpi.sh` - Creates full backup (database + files)
- `restore-glpi.sh` - Restores from backup

## Manual Backup (Anytime)
```bash
ssh root@10.0.3.13
sudo /usr/local/bin/backup-glpi.sh
```

Check results:
```bash
sudo tail -50 /var/log/glpi-backup/backup.log
ls -lh /mnt/backups/glpi-global/
```

## Automated Daily Backup

Scheduled via systemd timer at 1:00 AM UTC.

## Restore from Backup
```bash
ssh root@10.0.3.13

# List available backups
ls -lh /mnt/backups/glpi-global/glpi_backup_*.tar.gz

# Restore (will prompt for confirmation)
sudo /usr/local/bin/restore-glpi.sh /mnt/backups/glpi-global/glpi_backup_YYYYMMDD_HHMMSS.tar.gz
```

**WARNING:** This will drop the current database and restore from backup!

## What's Backed Up

- MariaDB database (glpi)
- GLPI application files
- Configuration files
- Plugins
- Document files

## First Successful Backup

- **Date:** 2026-01-08 12:08:31 CET
- **Database:** 129MB
- **Files:** 379MB
- **Compressed:** 100MB
- **Integrity:** ✓ Verified
- **Time:** 27 seconds

## Contacts

- GLPI Admin: guido.wilden@wefadetogrey.de
- Backup Owner: ops@company.de
