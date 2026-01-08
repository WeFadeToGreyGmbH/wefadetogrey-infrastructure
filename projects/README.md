# Infrastructure Projects

All company infrastructure projects managed here.

## Current Projects

- **glpi-global/** - Global GLPI server backup (company-wide)

## Planned Projects

- **backup/** - Local backups (databases, fileservers)
- **monitoring/** - Monitoring (prometheus, grafana, alerting)
- **deployment/** - Deployments (docker, kubernetes)
- **network/** - Network (opnsense, dns)
- **security/** - Security (vpn, ssh-keys, certificates)

## Project Structure
```
projects/PROJECT_NAME/
├── src/              # Scripts
├── config/           # Configuration
└── docs/            # Documentation
```

Each project is independently deployable.
