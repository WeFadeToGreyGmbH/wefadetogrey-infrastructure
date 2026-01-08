# GLPI Migration Plan: Physical → Docker

## Current Setup (Today)
```
Physical Server: 10.0.3.13
├─ GLPI application
├─ MySQL database
└─ Configuration files
```

**Backup Configuration:**
```
DEPLOYMENT_MODE="remote"
GLPI_HOST="10.0.3.13"
GLPI_DB_HOST="10.0.3.13"
```

---

## Future Setup (Planned)
```
Docker Container: 10.0.3.18
├─ GLPI application (Docker image)
├─ MySQL database (Docker or separate)
└─ Configuration files (mounted volumes)
```

**Backup Configuration:**
```
DEPLOYMENT_MODE="docker"
DOCKER_HOST="10.0.3.18"
DOCKER_CONTAINER="glpi"
GLPI_DB_HOST="localhost"
```

---

## Migration Steps

### Step 1: Prepare Docker Host (10.0.3.18)
- [ ] Set up Docker on 10.0.3.18
- [ ] Create Docker volumes for GLPI
- [ ] Create Docker volumes for MySQL

### Step 2: Migrate GLPI Data
- [ ] Export current GLPI database
- [ ] Export GLPI files and configuration
- [ ] Load into Docker containers

### Step 3: Test on Docker (Parallel)
- [ ] Run GLPI Docker container on 10.0.3.18
- [ ] Verify all data migrated correctly
- [ ] Test backups from Docker setup
- [ ] Run for 1-2 weeks in parallel

### Step 4: Update Backup Configuration
```bash
# Update projects/glpi-global/config/global/.env.global:
DEPLOYMENT_MODE="docker"
DOCKER_HOST="10.0.3.18"
DOCKER_CONTAINER="glpi"
GLPI_DB_HOST="localhost"
GLPI_SSH_HOST="10.0.3.18"
```

### Step 5: Redirect Traffic
- [ ] Update DNS/network routing to Docker GLPI
- [ ] Verify users can access GLPI on Docker

### Step 6: Decommission Physical Server
- [ ] Archive final backup from 10.0.3.13
- [ ] Decommission physical GLPI server
- [ ] Keep Docker as primary GLPI

### Step 7: Update Documentation
- [ ] Update all runbooks
- [ ] Update contact lists
- [ ] Update SLAs

---

## Key Points

✅ **No backup script changes needed** - Same script works for both
✅ **Configuration-driven migration** - Just update .env.global
✅ **Zero downtime** - Can run parallel during testing
✅ **Disaster recovery ready** - Both setups backed up same way

---

## Rollback Plan

If Docker migration fails:
```bash
# Restore to remote mode by updating .env.global:
DEPLOYMENT_MODE="remote"
GLPI_HOST="10.0.3.13"
GLPI_DB_HOST="10.0.3.13"
```

Everything rolls back to physical server.

---

## Timeline

- **Month 1-2:** Prepare Docker infrastructure
- **Month 2-3:** Migrate data, test in parallel
- **Month 3:** Cutover to Docker
- **Month 3-6:** Monitor, optimize
