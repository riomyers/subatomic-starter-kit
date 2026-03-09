# CLAUDE.md Validation Checklist

<!-- Lepton: Pre-flight Audit v1.0 -->
<!-- Run through this checklist before deploying your CLAUDE.md -->
<!-- Every check should pass. If it doesn't, fix it. -->

## Size & Structure

- [ ] **Under 200 lines** — Longer CLAUDE.md files burn tokens on every message. If yours is longer, move reference material to separate files and point to them.
- [ ] **Clear section headers** — Uses `##` headers that group related rules. Standard: Project, Code Standards, Git, Security, Testing, Deployment, Communication.
- [ ] **No walls of text** — Every section has short, scannable bullet points. No multi-paragraph explanations.
- [ ] **Logical ordering** — Most important rules first. Project identity at top, communication preferences at bottom.

## Content Quality

- [ ] **No vague instructions** — Search for: "best practices", "be careful", "write good code", "follow standards". Replace each with specific rules.
- [ ] **No permission language** — Search for: "you may", "feel free", "you can", "you're allowed". Replace with imperative: "Use X" / "Do Y".
- [ ] **No aspirational goals** — Search for: "production-ready", "scalable", "performant", "robust". Replace with measurable criteria.
- [ ] **Specific versions** — Framework versions specified: "Next.js 15 (App Router)" not just "Next.js". "React 19" not just "React".
- [ ] **Every "don't" has a "do"** — Each negative instruction includes the preferred alternative.
- [ ] **Every reference resolves** — Run: `grep -oP '\x60[^\x60]+\.(ts|js|json|md|py|go|rs)\x60' CLAUDE.md | tr -d '\x60' | while read f; do [ ! -f "$f" ] && echo "MISSING: $f"; done`

## Consistency

- [ ] **No contradictions** — Search for "always" and "never" — make sure they don't conflict with each other. Search for the same topic keyword across sections.
- [ ] **No duplicate rules** — Same rule shouldn't appear in two different sections with different wording.
- [ ] **Consistent naming** — If you call it `src/lib/` in one place, don't call it `src/utils/` elsewhere.
- [ ] **Consistent terminology** — Pick one: "component" or "module". "endpoint" or "route". "test" or "spec". Use it everywhere.

## Completeness

- [ ] **Project identity** — Stack, language, package manager, framework version all specified.
- [ ] **File structure** — Key directories mapped out. AI knows where components, routes, tests, and utilities live.
- [ ] **Git workflow** — Branch strategy, commit format, merge process documented.
- [ ] **Security basics** — At minimum: no hardcoded secrets, input validation, parameterized queries.
- [ ] **Build/deploy** — How to build, how to test, how to deploy. Commands specified.
- [ ] **Communication preferences** — How verbose should explanations be? When to ask vs. proceed?

## Efficiency

- [ ] **No documentation dumps** — API docs, specifications, and reference material live in separate files, not inline.
- [ ] **No example overload** — Maximum one code example per concept. More examples = more tokens wasted.
- [ ] **No commented-out sections** — Old rules deleted, not commented. Comments still burn tokens.
- [ ] **No obvious rules** — Not telling the AI to "use semicolons in JavaScript" or "import modules at the top of files."
- [ ] **Context file references** — Large reference docs pointed to by path, not pasted inline: "See `docs/api.md` for API reference."

## Cross-Platform (if using AGENTS.md)

- [ ] **No tool-specific syntax** — Core rules written in plain English that any AI tool understands.
- [ ] **Platform sections separate** — Tool-specific instructions in their own section (### Claude Code, ### Gemini CLI, etc.).
- [ ] **.cursorrules generated** — If using Cursor, the Rules section has been exported to `.cursorrules`.
- [ ] **File naming correct** — File is named `CLAUDE.md`, `AGENTS.md`, or `GEMINI.md` depending on the primary tool.

## Real-World Test

- [ ] **Fresh session test** — Start a new Claude Code session, give it a common task. Does it follow every rule? If it ignores a rule, the rule is poorly written.
- [ ] **Edge case test** — Ask for something that touches multiple rules (e.g., "add a new API route"). Does the AI follow all relevant rules (routing, validation, testing, git)?
- [ ] **Constraint test** — Ask for something your "don't" rules should prevent. Does the AI respect the constraints?

---

## Quick Fix Commands

### Find dead file references
```bash
grep -oP '`[^`]+\.(ts|js|json|md|py|go|rs)`' CLAUDE.md | tr -d '`' | while read f; do [ ! -f "$f" ] && echo "STALE: $f"; done
```

### Find duplicate rules
```bash
# Look for repeated key phrases
awk '{print tolower($0)}' CLAUDE.md | sort | uniq -d | grep -v '^$'
```

### Check line count
```bash
wc -l CLAUDE.md
# Target: under 200 lines
```

### Find vague language
```bash
grep -inE '(best practice|be careful|write good|feel free|you may|you can|production.ready|scalable|robust|performant)' CLAUDE.md
```

### Find contradictions
```bash
grep -inE '(always|never|must|do not|don.t)' CLAUDE.md
# Manually review: do any "always" and "never" rules conflict?
```
