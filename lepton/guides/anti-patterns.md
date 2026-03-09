# CLAUDE.md Anti-Patterns — The 20 Mistakes Killing Your AI Workflow

<!-- Lepton Anti-Patterns Guide v1.0 -->
<!-- Each anti-pattern includes: what it is, why it's bad, how to fix it -->

## Ghost Context Patterns (instructions that silently fail)

### 1. Vague Instructions
**Bad**: "Write good code" / "Follow best practices" / "Be careful with security"
**Why it fails**: These mean nothing — the model already tries to write good code. You're wasting tokens on platitudes.
**Fix**: Be specific. "Use parameterized queries for all SQL. Never concatenate user input into query strings."

### 2. Contradictory Rules
**Bad**: "Always write comprehensive tests" + later "Don't write tests unless asked"
**Why it fails**: The model picks whichever it processes last, or flips between them. You'll get inconsistent behavior and blame the AI.
**Fix**: Grep your CLAUDE.md for conflicting terms. Search for "always" and "never" — make sure they don't conflict. One rule per topic.

### 3. Orphaned References
**Bad**: "Follow the patterns in our style guide" (no link, no path, no content)
**Why it fails**: The model can't read your mind. It'll invent what it thinks your "style guide" says.
**Fix**: Either inline the rules, provide a file path it can read, or remove the reference entirely.

### 4. Platform-Specific Assumptions
**Bad**: "Deploy using our CI pipeline"
**Why it fails**: Which pipeline? Where? What triggers it? The model has no implicit knowledge of your infrastructure.
**Fix**: "Deploy to Vercel with `vercel --prod`. The production domain is app.example.com. Env vars are set in the Vercel dashboard."

### 5. Temporal References
**Bad**: "Use the new API endpoint" / "The recent migration changed..."
**Why it fails**: The CLAUDE.md is read fresh every session. There's no "new" or "recent" — there's only what's written.
**Fix**: Use absolute references. "Use the `/api/v2/users` endpoint (not the deprecated `/api/users`)."

---

## Context Bloat Patterns (burning tokens on noise)

### 6. Documentation Dumps
**Bad**: Pasting entire API documentation, README files, or specification documents into CLAUDE.md
**Why it fails**: Every token in CLAUDE.md is read on EVERY message. A 2000-line CLAUDE.md costs you on every single interaction. Most of it is irrelevant to any given task.
**Fix**: Keep CLAUDE.md under 200 lines. Move reference docs to separate files and tell the AI where to find them: "API docs are in `docs/api.md` — read it when working on API routes."

### 7. Example Overload
**Bad**: Including 10+ code examples to show your preferred style
**Why it fails**: One good example is worth ten mediocre ones. After the third example, you're just burning tokens.
**Fix**: One example per concept. Make it the BEST example. If you need more, reference a file: "See `src/components/Button.tsx` for our component pattern."

### 8. Redundant Rules
**Bad**: Saying the same thing three different ways across different sections
**Why it fails**: Token waste. Plus, subtle differences between the three phrasings can confuse the model about which version is authoritative.
**Fix**: State each rule once, in one place. Use `grep -n "keyword" CLAUDE.md` to find duplicates.

### 9. Commented-Out Sections
**Bad**: Keeping old rules as comments "just in case"
**Why it fails**: Comments still consume tokens. The model may still be influenced by commented text.
**Fix**: Delete old rules. Use git history if you need to recover them.

### 10. Over-Specified Obvious Behavior
**Bad**: "When writing JavaScript, use semicolons at the end of statements" / "Import modules at the top of files"
**Why it fails**: The model already knows JavaScript syntax. You're paying tokens to explain things a junior developer would know.
**Fix**: Only specify rules where you deviate from conventions or where the model commonly gets it wrong in YOUR codebase.

---

## Instruction Quality Patterns (bad rules that backfire)

### 11. Permission-Based Instructions
**Bad**: "You may use TypeScript" / "Feel free to add tests" / "You can use any library"
**Why it fails**: The model doesn't need permission. These instructions waste tokens and add ambiguity (does "may" mean "should"?).
**Fix**: Be imperative. "Use TypeScript strict mode." / "Write tests for new API routes." / "Prefer established libraries over custom implementations."

### 12. Negative-Only Rules
**Bad**: A CLAUDE.md that's entirely "Don't do X" with no "Do Y instead"
**Why it fails**: The model knows what NOT to do but not what you WANT. It becomes conservative and avoids doing anything creative.
**Fix**: For every "don't" include a "do instead": "Don't use `any` type — use `unknown` and narrow with type guards."

### 13. Aspirational Instructions
**Bad**: "Write production-ready code" / "Make it scalable" / "Ensure high performance"
**Why it fails**: These are outcomes, not instructions. The model can't measure "production-ready."
**Fix**: Define what production-ready means to YOU: "All API routes handle errors and return proper HTTP status codes. All user input is validated with Zod. All database queries use indexes."

### 14. Tool Instructions Without Context
**Bad**: "Use Prettier for formatting"
**Why it fails**: Is Prettier configured? What config? Should the model run it? Where's the config file?
**Fix**: "Prettier is configured in `.prettierrc`. Run `npx prettier --write .` before committing. The pre-commit hook runs it automatically."

### 15. Framework Version Ambiguity
**Bad**: "We use React" / "This is a Next.js project"
**Why it fails**: React 18 vs 19 have different patterns. Next.js Pages Router vs App Router are fundamentally different. The model may use the wrong patterns.
**Fix**: "Next.js 15 with App Router. React 19 with Server Components. Use `use` hook for promises, not `useEffect` for data fetching."

---

## Structural Patterns (poor organization)

### 16. No Clear Sections
**Bad**: A wall of text with no headers, no structure, just paragraphs of instructions
**Why it fails**: The model processes structured content better. Headers provide semantic grouping that improves instruction following.
**Fix**: Use clear markdown headers. Group related rules. Standard sections: Project, Code Standards, Git Workflow, Security, Deployment, Communication.

### 17. Mixing Concerns
**Bad**: Security rules scattered across 5 different sections
**Why it fails**: When rules about the same topic are spread out, some get forgotten. The model processes nearby rules more consistently.
**Fix**: One section per concern. All security rules in "## Security". All git rules in "## Git Workflow".

### 18. Missing the "Why"
**Bad**: "Always use `pnpm` instead of `npm`"
**Why it fails**: Without knowing why, the model might override this rule when it seems inconvenient (e.g., a tutorial uses npm).
**Fix**: "Use `pnpm` (not npm/yarn) — the project uses pnpm workspaces and the lockfile is `pnpm-lock.yaml`."

### 19. No File Structure Map
**Bad**: Expecting the AI to understand your project layout from repo exploration alone
**Why it fails**: The model wastes 3-5 tool calls exploring your directory structure at the start of every session. That's tokens AND time.
**Fix**: Include a brief file structure section: where components live, where API routes go, where tests belong. 10 lines saves 50 tool calls per week.

### 20. Stale Instructions
**Bad**: CLAUDE.md references files, patterns, or tools that no longer exist in the project
**Why it fails**: The model follows the instruction, hits a wall, wastes time investigating, then asks you about it. Worst case: it recreates deleted files.
**Fix**: Review your CLAUDE.md quarterly. After major refactors, update it immediately. Run: `grep -oP '`[^`]+\.(ts|js|json|md)`' CLAUDE.md | xargs -I{} test -f {} || echo "STALE: {}"` to find dead references.

---

## The Golden Rules

1. **Shorter is better** — Every line should earn its tokens. If removing a line doesn't change behavior, remove it.
2. **Specific beats general** — "Use Tailwind v4 `@apply` sparingly" beats "Follow CSS best practices."
3. **One rule, one place** — Never say the same thing twice. Duplicates drift and conflict.
4. **Imperative mood** — "Use X" not "You should consider using X" or "It's recommended to use X."
5. **Test your CLAUDE.md** — Start a fresh session, give a task, see if the AI follows every rule. If it doesn't, the rule is broken.
