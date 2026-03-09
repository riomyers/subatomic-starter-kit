# CLAUDE.md Migration Guide

<!-- Lepton: Upgrade Your Existing CLAUDE.md v1.0 -->
<!-- Step-by-step process to audit, clean, and upgrade any CLAUDE.md -->

## Step 1: Measure Current State

Run these commands against your existing CLAUDE.md:

```bash
# Line count (target: under 200)
echo "Lines: $(wc -l < CLAUDE.md)"

# Vague language count
echo "Vague phrases: $(grep -ciE '(best practice|be careful|write good|feel free|you may|you can|production.ready|scalable|robust|performant|high quality)' CLAUDE.md)"

# Dead references
echo "Checking file references..."
grep -oP '`[^`]+\.(ts|js|json|md|py|go|rs)`' CLAUDE.md | tr -d '`' | while read f; do [ ! -f "$f" ] && echo "  STALE: $f"; done

# Constraint language
echo "Permission phrases: $(grep -ciE '(you may|feel free|you can|you.re allowed|consider using)' CLAUDE.md)"

# Contradiction risk
echo "--- Review these for conflicts ---"
grep -inE '(always|never|must|do not|don.t)' CLAUDE.md
```

### Scoring
| Metric | Good | Okay | Bad |
|--------|------|------|-----|
| Lines | < 150 | 150-300 | > 300 |
| Vague phrases | 0 | 1-3 | > 3 |
| Dead references | 0 | 1-2 | > 2 |
| Permission phrases | 0 | 1-2 | > 2 |

## Step 2: Identify Ghost Context

Ghost context = instructions that look correct but silently fail. Common causes:

### Orphaned References
Look for mentions of files, functions, or patterns that no longer exist:
```bash
# Find all backtick-quoted paths and check if they exist
grep -oP '`[^`]+`' CLAUDE.md | sort -u
# Manually verify each one still exists in your project
```

### Contradictions
Search for rule pairs that cancel each other out:
```bash
grep -n 'test' CLAUDE.md
# Do you say "always write tests" AND "don't write tests unless asked"?

grep -n 'commit' CLAUDE.md
# Do you say "commit frequently" AND "only commit when asked"?
```

### Temporal Language
Search for words that imply time — they're meaningless in a file that's read fresh each session:
```bash
grep -inE '(recently|new|old|deprecated|current|latest|updated|changed|moved)' CLAUDE.md
# Replace with absolute references: "Use v2 API at /api/v2/" not "Use the new API"
```

## Step 3: Restructure

Take your existing content and reorganize into these standard sections:

```markdown
# CLAUDE.md

## Project
[3-5 lines: name, stack, language, package manager, key facts]

## Code Standards
[Architecture, style rules, naming, patterns]

## File Structure
[Directory map — 10-15 lines showing where things live]

## Git Workflow
[Branch strategy, commit format, merge process]

## Security
[Secrets management, input validation, auth]

## Testing
[Framework, what to test, commands]

## Deployment
[Platform, commands, environment management]

## Communication
[How verbose, when to ask, explanation style]
```

### Migration Steps
1. Create a new file: `CLAUDE.md.new`
2. For each section above, pull relevant rules from your existing file
3. As you move rules, apply the fixes from Step 4
4. Delete the old file, rename the new one
5. Run the validation checklist (see `validation-checklist.md`)

## Step 4: Fix Common Issues

### Fix Vague Language
| Before | After |
|--------|-------|
| "Write clean, maintainable code" | "Functions under 50 lines. One responsibility per function." |
| "Follow security best practices" | "Parameterized queries for SQL. Validate input with Zod. Secrets in env vars." |
| "Use appropriate error handling" | "API routes return typed error objects: `{ error: { code, message } }`. Catch specific exceptions, not generic Error." |
| "Write production-ready code" | "All API routes handle errors. User input validated. No hardcoded secrets." |

### Fix Permission Language
| Before | After |
|--------|-------|
| "You may use TypeScript" | "Use TypeScript strict mode" |
| "Feel free to add tests" | "Add tests for new API routes" |
| "You can use any library" | "Prefer established libraries. Check if an existing dependency covers the need before adding new ones." |
| "Consider using Tailwind" | "Use Tailwind v4 utility classes for all styling" |

### Fix Aspirational Goals
| Before | After |
|--------|-------|
| "Make it scalable" | "Use pagination for list endpoints. Cache expensive queries." |
| "Ensure performance" | "Lighthouse Performance > 90. Lazy-load below-fold components." |
| "Write robust error handling" | "Every API route has try/catch. Errors return `{ error: { code, message } }` with appropriate HTTP status." |

### Fix Missing Context
| Before | After |
|--------|-------|
| "We use React" | "React 19 with Server Components (Next.js 15 App Router)" |
| "Deploy to production" | "Deploy to Vercel: `vercel --prod`. Production domain: app.example.com" |
| "Follow our style guide" | "ESLint + Prettier configured in `.eslintrc.js`. Run `pnpm lint` to check." |

## Step 5: Trim the Fat

### Delete If Present
- [ ] Lines that describe what the AI already knows (JavaScript syntax, how imports work)
- [ ] Commented-out old rules
- [ ] Multi-paragraph explanations (replace with one-line rules)
- [ ] More than one example per concept
- [ ] Documentation that should live in separate files
- [ ] Rules that repeat default AI behavior ("read files before editing" — most AI tools do this)

### Extract If Too Long
Move these to separate files and reference them:
- API documentation → `docs/api.md`
- Database schema details → `docs/schema.md`
- Deployment runbook → `docs/deploy.md`
- Style guide examples → `docs/style-guide.md`

Reference them: "For API documentation, see `docs/api.md`."

## Step 6: Validate

Run the full validation checklist (`validation-checklist.md`).

Then test in a real session:
1. Start a fresh Claude Code / Gemini CLI session
2. Ask it to do something that touches multiple rules
3. Check: Did it follow every relevant rule?
4. If not: the violated rule needs rewriting — it's not specific enough

## Step 7: Maintain

### Quarterly Review
- Re-run the measurement commands from Step 1
- Check for stale file references (files that moved or were deleted)
- Update framework versions if they changed
- Remove rules that are no longer relevant

### After Major Refactors
- Update file structure section immediately
- Search for old path references: `grep -n 'old/path' CLAUDE.md`
- Update architecture rules if patterns changed

### After Adding New Tools
- Add tool configuration to the relevant section
- Update the communication section if new tools change the workflow
- If adding MCP servers, update the routing table
