# Photon — Token Optimizer

Pay $19 to save $50/month in API costs. Analyzes your project and generates optimized .aiignore files.

## Tools

- `analyzer-script.sh` — Per-file token cost analysis with directory breakdown
- `aiignore-generator.sh` — Smart .aiignore generator with framework detection
- `aiignore-templates.md` — Pre-built templates for 5 project types
- `token-budget-guide.md` — Context budget guide with ROI calculator

## Usage

```bash
# Analyze token costs
./analyzer-script.sh /path/to/project

# Generate .aiignore (dry run first)
./aiignore-generator.sh /path/to/project --dry-run

# Generate for real
./aiignore-generator.sh /path/to/project

# Use a preset
./aiignore-generator.sh /path/to/project --preset nextjs
```

## Why This Matters

The average project sends 5.5x more context than necessary. Lock files alone can waste 200K+ tokens per session. Photon identifies what's wasting your budget and fixes it automatically.
