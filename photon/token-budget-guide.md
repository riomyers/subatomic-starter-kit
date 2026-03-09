# Photon — Token Budget Guide

## Understanding Your Context Budget

Every AI coding tool has a context window — the maximum amount of text it can process at once.

| Tool | Context Window | Effective Budget* |
|------|---------------|-------------------|
| Claude Code (Opus 4) | 200K tokens | ~120K usable |
| Claude Code (Sonnet 4) | 200K tokens | ~120K usable |
| Gemini CLI | 1M tokens | ~600K usable |
| Cursor | 128K tokens | ~80K usable |
| Codex | 200K tokens | ~120K usable |

*Effective budget = total window minus system prompts, tool definitions, conversation history, and MCP overhead.

## Where Your Tokens Go

In a typical Claude Code session:

| Category | Token Usage | % of Budget |
|----------|------------|-------------|
| System prompt + CLAUDE.md | 2K-10K | 2-8% |
| MCP tool definitions | 5K-15K | 4-12% |
| Conversation history | 10K-50K | 8-40% |
| File reads (your code) | 20K-100K | 16-80% |
| Tool results | 5K-30K | 4-25% |

**The #1 budget killer: reading large files and directories.** Every `Read` tool call loads the file into context. Every `Grep` result adds content. This accumulates fast.

## Token Cost Per File Type

Approximate tokens per 100 lines of code:

| File Type | Tokens/100 Lines | Why |
|-----------|-----------------|-----|
| TypeScript/JavaScript | 400-600 | Moderate verbosity |
| Python | 300-500 | Concise syntax |
| Go | 350-500 | Explicit, less syntactic sugar |
| JSON | 200-400 | Lots of structure, few words |
| Markdown | 250-400 | Natural language, varies |
| YAML/TOML | 200-300 | Key-value pairs |
| CSS/SCSS | 300-500 | Property-value pairs |
| SQL | 250-400 | Keywords + identifiers |
| HTML/JSX | 400-700 | Verbose tags and attributes |

## How .aiignore Saves Money

### Without .aiignore
AI tool explores your project → reads every file it finds relevant → quickly fills context → loses early conversation → starts hallucinating

### With .aiignore
AI tool skips excluded files → reads only source code → context stays lean → maintains full conversation history → stays accurate

### Real-World Example

**Next.js project (medium, ~500 files):**

| With .aiignore | Without .aiignore |
|----------------|-------------------|
| 120 files indexed | 12,000+ files indexed |
| 50K tokens of code | 2M+ tokens of code |
| Full conversation fit | Context overflow in 5 messages |
| $0.50/session | $5-10/session |

## Optimization Strategies

### Strategy 1: Exclude Everything That's Generated
Lock files, build output, source maps, type declarations, migration files — if it's generated, the AI doesn't need to read it.

### Strategy 2: Exclude Large Reference Files
API specs, schema files, documentation — point to them in CLAUDE.md with "see docs/api.md" but exclude them from default indexing.

### Strategy 3: Scope Your Sessions
When working on the frontend, you don't need backend files in context. Use `.aiignore` or explicit file scoping.

### Strategy 4: Compress Your CLAUDE.md
Your CLAUDE.md is loaded on EVERY message. A 500-line CLAUDE.md costs ~2K tokens × every message × 20 messages/session = 40K tokens wasted. Keep it under 200 lines.

### Strategy 5: Use External Tools for Heavy Analysis
Route multi-file analysis to external AI tools (PAL, Gemini CLI) instead of loading all files into Claude's context. This is what Boson (MCP Routing Playbook) is for.

## Monitoring Your Usage

### Check Current Session Token Usage
Claude Code shows token usage in the status bar. Watch for:
- Rapid context growth (reading many files)
- Context compression warnings (you've exceeded the window)
- Slow responses (model processing large context)

### Run Photon Analyzer
```bash
bash photon-analyze.sh /path/to/project
```
Shows per-file and per-directory token costs, context window utilization, and optimization suggestions.

## ROI Calculator

| Monthly API Spend | With Photon Savings (60%) | Annual Savings |
|-------------------|--------------------------|----------------|
| $50/mo | $30/mo saved | $360/yr |
| $100/mo | $60/mo saved | $720/yr |
| $200/mo | $120/mo saved | $1,440/yr |
| $500/mo | $300/mo saved | $3,600/yr |

Photon costs $19 once. Pays for itself in the first week for most developers.
