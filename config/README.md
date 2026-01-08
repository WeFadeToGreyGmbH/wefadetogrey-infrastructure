# Configuration Hierarchy

All infrastructure configurations organized by scope.

## Structure

- **global/** - Applied to all offices everywhere
- **countries/** - Country-specific settings (GER, ESP, FRA)
  - Each country has offices/ with specific configs

## How It Works

When deploying to CGN-HANSARING:
1. Load global config (config/global/.env.global)
2. Override with Germany config (config/countries/GER/.env.GER)
3. Override with CGN-HANSARING config (config/countries/GER/offices/CGN-HANSARING/.env.CGN-HANSARING)
4. Result: Configuration ready for deployment

All projects use same hierarchy.

## Files

- `global/.env.global` - Global defaults (applies to all local projects)
- `countries/GER/.env.GER` - Germany-wide settings
- `countries/GER/offices/CGN-HANSARING/.env.CGN-HANSARING` - Hansaring specifics
- `countries/GER/offices/CGN-MMC/.env.CGN-MMC` - MMC specifics

## Note: GLPI Configuration

GLPI has separate configuration in `projects/glpi-global/config/global/.env.global` (not in this directory).
