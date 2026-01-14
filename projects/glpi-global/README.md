# Global GLPI Backup

Backup and disaster recovery for THE company-wide GLPI instance.

## Status

✅ **Single Global GLPI Server**
- Current: Physical server on 10.0.3.13
- Purpose: Company-wide asset inventory

## Quick Start
```bash
./scripts/deploy-glpi-backup.sh
```

## Backup Schedule

- **Daily backups** at 1:00 AM UTC
- **Retention**: 90 days
- **Backup location**: /mnt/backups/glpi-global/
- **Verification**: Automatic integrity checks

## Configuration

- **Current mode**: Remote (10.0.3.13)
- **Config file**: `config/global/.env.global`

## Contacts

- GLPI Administrator: guido.wilden@wefadetogrey.de
- Backup Owner: engineering@wefadetogrey.de
