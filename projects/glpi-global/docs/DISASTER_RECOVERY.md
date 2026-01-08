# Disaster Recovery Plan - GLPI

## Scenario: GLPI Server (10.0.3.13) Complete Failure

### Recovery Steps

**Phase 1: Assess (0-30 min)**
1. Confirm 10.0.3.13 is down
2. SSH to backup location: `ssh root@10.0.3.13`
3. Locate latest backup: `ls -lh /mnt/backups/glpi-global/ | tail -5`
4. Verify backup integrity: `tar -tzf /mnt/backups/glpi-global/glpi_backup_LATEST.tar.gz > /dev/null`

**Phase 2: Prepare New Server (30 min - 2 hours)**
1. Deploy new Ubuntu 22.04 server
2. Install MariaDB, Apache, GLPI
3. Copy backup scripts from repository

**Phase 3: Restore Data (30 min)**
```bash
sudo /usr/local/bin/restore-glpi.sh /mnt/backups/glpi-global/glpi_backup_LATEST.tar.gz
```

**Phase 4: Verify (30 min)**
1. Access GLPI web interface
2. Verify user accounts
3. Check asset inventory
4. Test permissions

**Phase 5: Redirect Traffic (15 min)**
1. Update firewall rules
2. Or reconfigure reverse proxy

### Expected RTO: 3-4 hours
### Expected RPO: Less than 1 day (daily backups)

## Backup Storage

**Current:** 10.0.3.13:/mnt/backups/glpi-global/

**Future recommendations:**
- [ ] Off-server backup copy to 10.0.3.18
- [ ] Cloud backup (AWS S3, etc.)
- [ ] Replicated backup drive

## Testing Schedule

- Monthly: Verify latest backup
- Quarterly: Full restore test
- Annually: Full DR drill

## Contacts

- Primary: guido.wilden@wefadetogrey.de
- Backup: ops@company.de
