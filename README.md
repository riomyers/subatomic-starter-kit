# Subatomic Starter Kit

**Free tools to make your AI coding agent actually good.**

Stop fighting your AI assistant. These two products — extracted from the full [Subatomic](https://subatomic.pro) arsenal — solve the most common problems developers face with AI coding tools.

## What's Inside

### Gluon — Anti-Slop Framework
Kill AI boilerplate. 40+ rules that eliminate hedging, filler, and "Certainly!" from every AI response.

- `anti-slop-rules.md` — The complete rule set, categorized by slop type
- `claude-md-snippet.md` — Drop-in CLAUDE.md snippet (copy, paste, done)
- `gemini-config.md` — Equivalent config for Gemini CLI
- `examples.md` — Before/after examples showing the difference

**Result**: 65% noise reduction in real sessions. Your AI stops writing essays and starts writing code.

### Preon — Project Bootstrapper (Sample)
One command to make any project AI-ready. Detects your stack, generates configs for every AI platform.

- `detect-stack.sh` — Auto-detect your framework, language, and package manager
- `sample-template.md` — React + Vite CLAUDE.md template (1 of 10 included in full version)

**Result**: Skip hours of manual config. Full version generates CLAUDE.md, .cursorrules, GEMINI.md, hooks, and .aiignore in one command.

## Quick Start

```bash
# Clone this repo
git clone https://github.com/riomyers/subatomic-starter-kit.git

# Drop anti-slop rules into your project
cat subatomic-starter-kit/gluon/claude-md-snippet.md >> your-project/CLAUDE.md

# Detect your project's stack
bash subatomic-starter-kit/preon/detect-stack.sh /path/to/your/project
```

## Want More?

The Starter Kit is 2 of 14 active Subatomic products. The full arsenal includes:

| Product | What It Does | Price |
|---------|-------------|-------|
| **Isotope** | Autonomous agent system with self-learning brain daemon | $99 |
| **Sentinel** | PII & secret scrubber — intercepts before AI sees your data | $79 |
| **Muon** | 15+ safety hooks — blocks destructive commands, detects leaks | $69 |
| **Neutrino** | Autonomous debug loop — 7-step cycle that actually fixes bugs | $69 |
| **Photon** | Context guardian — backup/restore state across compaction | $59 |
| **Quark** | Context linter + 8 battle-tested CLAUDE.md templates | $59 |
| **Fermion** | Multi-repo knowledge graph — cross-project search & deps | $59 |
| **Tachyon** | Real-time token budget dashboard with auto-pruning | $49 |
| **Reactor** | MCP command center — routing tables + 5 pre-tested server stacks | $49 |
| **Meson** | 50+ curated workflow recipes for real dev tasks | $39 |
| **Hadron** | Cross-platform converter — CLAUDE.md to Cursor, Gemini, Codex | $29 |
| **Valence** | Team shared memory & configuration sync | $19/mo |

**Bundles save 25-30%:**
- **Particle Pack** ($119) — Quark + Gluon + Tachyon + Photon
- **Shield Wall** ($199) — Muon + Sentinel + Reactor + Neutrino
- **The Standard Model** ($499) — All 13 one-time products

Browse the full catalog at [subatomic.pro](https://subatomic.pro).

## License

MIT — use these tools however you want. Attribution appreciated but not required.

---

Built by [Subatomic](https://subatomic.pro) — premium infrastructure for AI coding tools.
