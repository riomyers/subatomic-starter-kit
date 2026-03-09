# AGENTS.md — Universal AI Agent Configuration

<!-- Lepton: AGENTS.md Universal Format v1.0 -->
<!-- Write once. Works on Claude Code, Gemini CLI, Cursor, Codex, Windsurf, Aider. -->
<!--
  This format is a superset. Each tool reads what it understands and ignores the rest.
  Claude Code reads: everything (CLAUDE.md or AGENTS.md)
  Gemini CLI reads: everything (GEMINI.md or AGENTS.md)
  Cursor reads: .cursorrules (convert with the mapping below)
  Codex reads: AGENTS.md natively
  The key is: write in plain imperative English, avoid tool-specific syntax.
-->

## Identity

<!-- WHO is the AI when working on this project? -->
- **Name**: [e.g., Default | Custom persona name]
- **Role**: [e.g., Senior full-stack developer | DevOps engineer | Data scientist]
- **Tone**: [e.g., Direct and concise | Detailed and educational | Terse and technical]

## Project

<!-- WHAT is this project? Keep it to 3-5 lines max. -->
[PROJECT_NAME] — [one-line description].

| Key | Value |
|-----|-------|
| Stack | [e.g., Next.js 15, Tailwind v4, Supabase, Stripe] |
| Language | [e.g., TypeScript strict] |
| Package Manager | [e.g., pnpm] |
| Node Version | [e.g., 22.x] |

## Rules

<!-- HOW should the AI behave? Imperative mood. One rule per line. -->

### Code Style
- [e.g., Use TypeScript strict mode — no `any` types]
- [e.g., Functional components with hooks, no class components]
- [e.g., Named exports only, no default exports except pages]
- [e.g., Tailwind utility classes for all styling]

### Architecture
- [e.g., Feature-based directory structure in `src/features/`]
- [e.g., Server Components for data fetching, Server Actions for mutations]
- [e.g., All database queries go through `src/lib/db.ts`]

### Testing
- [e.g., Vitest for unit tests, Playwright for E2E]
- [e.g., Test happy path + one error case minimum]
- [e.g., Run `pnpm test` after significant changes]

### Security
- [e.g., Environment variables for all secrets]
- [e.g., Parameterized queries only — never concatenate SQL]
- [e.g., Validate all user input with Zod at system boundaries]

### Git
- [e.g., Work on `dev` branch, PR to `main`]
- [e.g., Conventional commits: feat:, fix:, chore:]
- [e.g., Build before merging: `pnpm build`]

## Files

<!-- WHERE are things? Map your project structure. -->
```
src/
  app/              # Pages and layouts
  components/       # Shared UI components
  features/         # Feature modules
  lib/              # Shared utilities
  types/            # TypeScript types
```

## Constraints

<!-- What should the AI NEVER do? -->
- Don't add features beyond what was asked
- Don't create new files unless necessary
- Don't add comments to unchanged code
- Don't refactor surrounding code while fixing a bug
- Read a file before editing — no exceptions
- If a fix fails twice, stop and ask

## Context Files

<!-- Optional: Tell the AI where to find reference docs without loading them into context -->
<!-- This section is the key to avoiding context bloat -->
- API documentation: `docs/api.md` (read when working on API routes)
- Database schema: `prisma/schema.prisma` (read when writing queries)
- Component patterns: `src/components/ui/Button.tsx` (read for component conventions)
- Test patterns: `tests/example.test.ts` (read when writing tests)

---

## Platform-Specific Notes

<!-- These sections are read by their respective tools and ignored by others -->

### Claude Code
<!-- Anything Claude Code-specific: hooks, MCP routing, skills -->
- [e.g., MCP routing: PAL for code review, Context7 for library docs]
- [e.g., Use hooks for pre-commit validation]

### Gemini CLI
<!-- Anything Gemini CLI-specific -->
- [e.g., Use @file references for large context reads]
- [e.g., Prefer inline code blocks over file creation for small snippets]

### Cursor
<!-- Convert to .cursorrules format for Cursor IDE -->
<!-- Cursor reads .cursorrules, not AGENTS.md -->
<!-- Copy the Rules section above into .cursorrules as plain text -->

### Codex
<!-- Codex-specific instructions -->
- [e.g., Run in full-auto mode with sandbox enabled]

---

## Conversion Guide

### AGENTS.md → .cursorrules
Copy the Rules section as plain text. Cursor doesn't use markdown headers, but it reads the content fine. Remove the `## Rules` header and flatten:
```
Use TypeScript strict mode — no `any` types.
Functional components with hooks, no class components.
Named exports only, no default exports except pages.
...
```

### AGENTS.md → CLAUDE.md
Rename the file. Claude Code reads AGENTS.md natively, but if you prefer CLAUDE.md, just rename it. Both work identically.

### AGENTS.md → GEMINI.md
Rename to GEMINI.md or keep as AGENTS.md. Gemini CLI reads both.

### AGENTS.md → codex.md
Codex reads AGENTS.md natively. No conversion needed.
