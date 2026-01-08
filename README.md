# WeFadeToGrey Infrastructure Repository

Professional infrastructure-as-code repository for managing all company infrastructure.

## Architecture

**Global Services:**
- GLPI - One central server for company-wide inventory

**Local Infrastructure (Per-Office):**
- Backups - Database and file server backups
- Monitoring - Prometheus metrics and alerts
- Deployment - Docker container orchestration
- Network - Firewall and network configuration
- Security - VPN and access management

## Current Setup

**Server:** cgn-hansaring-docker-01
**Locations:** CGN-HANSARING, CGN-MMC (Germany)

## Repository Structure
```
projects/
├── glpi-global/              ← THE global GLPI (company-wide)
├── backup/                   ← Local backups (per-office)
├── monitoring/               ← Local monitoring (per-office)
├── deployment/               ← Local deployments (per-office)
├── network/                  ← Local networking (per-office)
└── security/                 ← Local security (per-office)

config/
├── global/                   ← Defaults for local projects
└── countries/GER/offices/    ← Office-specific configurations

docs/
├── glpi-global/              ← GLPI documentation
├── projects/                 ← Project documentation
└── countries/                ← Location documentation
```

## Configuration Hierarchy
```
Global defaults (config/global/.env.global)
    ↓
Country settings (config/countries/GER/.env.GER)
    ↓
Office specifics (config/countries/GER/offices/CGN-HANSARING/.env.CGN-HANSARING)
```

## Quick Reference

- Global GLPI backed up: `./scripts/deploy-glpi-backup.sh`
- Deploy local project: `./scripts/deploy-project.sh <project> <subproject> <country> <office>`
- Deploy all local to office: `./scripts/deploy-office.sh <country> <office>`

## Locations

| Code | Office | Server |
|------|--------|--------|
| CGN-HANSARING | Cologne Hansaring | cgn-hansaring-docker-01 |
| CGN-MMC | Cologne MMC | cgn-hansaring-docker-01 |

## Status

✅ Repository structure initialized
✅ Configuration hierarchy created
✅ GLPI migration plan documented
⏳ Deployment scripts and GLPI backup files to be added

## Next Steps

See [FINAL_INFRASTRUCTURE_STRUCTURE.md](FINAL_INFRASTRUCTURE_STRUCTURE.md) and [FINAL_IMPLEMENTATION.md](FINAL_IMPLEMENTATION.md) in the outputs directory.
