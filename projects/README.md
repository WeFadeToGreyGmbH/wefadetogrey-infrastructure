# Infrastructure Projects

All company infrastructure projects managed here.

## Current Projects

- **glpi-global/** - Global GLPI server backup (company-wide inventory)

## Planned Projects

- **backup/** - Local backup solutions (databases, files)
  - databases/ - Database backups per-office
  - fileservers/ - File server backups per-office
- **monitoring/** - Monitoring and alerting
  - prometheus/ - Metrics collection
  - grafana/ - Dashboards
  - alerting/ - Alert rules
- **deployment/** - Deployment automation
  - docker/ - Container deployments
  - kubernetes/ - Kubernetes configs (future)
- **network/** - Network infrastructure
  - opnsense/ - Firewall management
  - dns/ - DNS management
- **security/** - Security management
  - vpn/ - VPN configurations
  - ssh-keys/ - SSH key management
  - certificates/ - SSL certificate management

## Project Structure

Each project follows this pattern:
```
projects/PROJECT_NAME/
├── src/              # Scripts and code
├── config/           # Configuration files
│   ├── global/      # Global defaults
│   └── countries/   # Country-specific configs
└── docs/            # Project documentation
```

## Deployment

Each project can be deployed independently or with others:
```bash
# Deploy specific project to office
./scripts/deploy-project.sh <project> <subproject> <country> <office>

# Deploy all projects to office
./scripts/deploy-office.sh <country> <office>
```

## Adding New Project

1. Create directory: `mkdir -p projects/PROJECTNAME/{src,config,docs}`
2. Add scripts to `src/`
3. Add config templates to `config/global/` and `config/countries/`
4. Add documentation to `docs/`
5. Create `README.md` in project root
6. Commit and push

See [FINAL_INFRASTRUCTURE_STRUCTURE.md](../FINAL_INFRASTRUCTURE_STRUCTURE.md) for details.
