# Configuration Hierarchy

All infrastructure configurations organized by scope.

## Structure

- **global/** - Applied to all offices everywhere
- **countries/** - Country-specific settings (GER, ESP, FRA)

## How It Works

Configuration loads in order (last wins):
1. Load global config
2. Override with country config
3. Override with office config

Result = Configuration ready for deployment

## Files

- `global/.env.global` - Global defaults
- `countries/GER/.env.GER` - Germany-wide settings
- `countries/GER/offices/CGN-HANSARING/.env.CGN-HANSARING` - Hansaring specifics
- `countries/GER/offices/CGN-MMC/.env.CGN-MMC` - MMC specifics

## Note: GLPI Configuration

GLPI has separate configuration in `projects/glpi-global/config/global/.env.global`
