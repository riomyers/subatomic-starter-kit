# Subatomic Starter Kit

**Free tools to make your AI coding agent actually good.**

Stop fighting your AI assistant. These three products — extracted from the full [Subatomic](https://subatomic.pro) arsenal — solve the most common problems developers face with Claude Code, Gemini CLI, Cursor, and Codex.

## What's Inside

### Gluon — Anti-Slop Framework
Kill AI boilerplate. 40+ rules that eliminate hedging, filler, and "Certainly!" from every AI response.

- `anti-slop-rules.md` — The complete rule set, categorized by slop type
- `claude-md-snippet.md` — Drop-in CLAUDE.md snippet (copy → paste → done)
- `gemini-config.md` — Equivalent config for Gemini CLI
- `examples.md` — Before/after examples showing the difference

**Result**: 65% noise reduction in real sessions. Your AI stops writing essays and starts writing code.

### Photon — Token Optimizer
Understand where your tokens go and stop wasting money.

- `analyzer-script.sh` — Scan any project for token costs per file and directory
- `aiignore-generator.sh` — Auto-generate `.aiignore` files to exclude bloat from AI context
- `aiignore-templates.md` — Pre-built templates for Next.js, Python, Go, Rust, and more
- `token-budget-guide.md` — Complete guide to context budgets across every AI tool

**Result**: 60% token savings. Pays for itself in the first week if you upgraded.

### Lepton — Pro CLAUDE.md Templates
Battle-tested templates that solve the #1 developer pain point: ghost context.

**8 templates** for every project type:
- `solo-dev.md` — Solo developer projects
- `team-project.md` — Shared repos with multiple devs
- `frontend-app.md` — React/Vue/Svelte SPAs and SSR apps
- `api-service.md` — REST APIs and backend services
- `monorepo.md` — Turborepo, Nx, pnpm workspaces
- `data-pipeline.md` — ETL, analytics, ML pipelines
- `devops.md` — Infrastructure, CI/CD, platform engineering
- `open-source.md` — Public repos with external contributors

**Plus**:
- `agents-md/AGENTS.md` — Universal format that works on Claude Code, Gemini CLI, Cursor, and Codex
- `guides/anti-patterns.md` — The 20 mistakes killing your AI workflow
- `guides/migration-guide.md` — Step-by-step upgrade for your existing CLAUDE.md
- `guides/validation-checklist.md` — Pre-flight audit before deploying your config

## Quick Start

```bash
# Clone this repo
git clone https://github.com/riomyers/subatomic-starter-kit.git

# Drop anti-slop rules into your project
cat subatomic-starter-kit/gluon/claude-md-snippet.md >> your-project/CLAUDE.md

# Generate a .aiignore for your project
bash subatomic-starter-kit/photon/aiignore-generator.sh /path/to/your/project

# Copy the right template for your project type
cp subatomic-starter-kit/lepton/templates/solo-dev.md your-project/CLAUDE.md
# Then customize the [BRACKETS] with your project specifics
```

## Want More?

The Starter Kit is 3 of 13 Subatomic products. The full arsenal includes:

| Product | What It Does | Price |
|---------|-------------|-------|
| **Isotope** | Autonomous agent system with self-learning brain daemon | $99 |
| **Sentinel** | PII & secret scrubber — intercepts before AI sees your data | $79 |
| **Muon** | 15+ safety hooks — blocks destructive commands, detects leaks | $69 |
| **Neutrino** | Autonomous debug loop — 7-step cycle that actually fixes bugs | $69 |
| **Fermion** | Multi-repo knowledge graph — cross-project search & deps | $59 |
| **Tachyon** | Real-time token budget dashboard with auto-pruning | $49 |
| **Quark** | Context linter — scans CLAUDE.md for anti-patterns | $49 |
| **Hadron** | Cross-platform converter — CLAUDE.md ↔ Cursor ↔ Gemini ↔ Codex | $49 |
| **Reactor** | Curated MCP server stacks — Docker configs that just work | $39 |
| **Boson** | MCP routing playbook — make your AI actually use its tools | $29 |

**Bundles save 25-30%:**
- **Particle Pack** ($99) — Lepton + Quark + Gluon + Tachyon
- **Shield Wall** ($179) — Muon + Sentinel + Boson + Neutrino
- **The Standard Model** ($449) — Everything. All 13 products.

Browse the full catalog at [subatomic.pro](https://subatomic.pro).

## License

MIT — use these tools however you want. Attribution appreciated but not required.

---

Built by [Subatomic](https://subatomic.pro) — premium infrastructure for AI coding tools.
