# Backup Troubleshooting

## Backup Fails - MySQL Connection Error

**Symptom:** "ERROR: Database backup failed"

**Solution:**
```bash
ssh root@10.0.3.13
sudo systemctl status mysql
mysql -e "SELECT VERSION();"
mysql -e "SHOW DATABASES;" | grep glpi
```

## Not Enough Disk Space

**Symptom:** "No space left on device"

**Solution:**
```bash
ssh root@10.0.3.13
df -h /mnt/backups/
```

## Restore Fails

**Symptom:** Database restore doesn't work

**Solution:**
1. Verify backup is valid: `tar -tzf /mnt/backups/glpi-global/glpi_backup_YYYYMMDD_HHMMSS.tar.gz`
2. Check MySQL is running: `sudo systemctl status mysql`
3. Ensure root access to MySQL

## Corrupted Backup

**Symptom:** "tar: unexpected EOF"

**Solution:**
```bash
ssh root@10.0.3.13
# Check file size
ls -lh /mnt/backups/glpi-global/glpi_backup_*.tar.gz
# Verify integrity
tar -tzf /mnt/backups/glpi-global/glpi_backup_LATEST.tar.gz > /dev/null
```

## Support

Contact: guido.wilden@wefadetogrey.de
