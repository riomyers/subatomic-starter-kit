# CLAUDE.md — Solo Developer

<!-- Lepton Template: Solo Dev v1.0 -->
<!-- Replace all [BRACKETS] with your project specifics -->
<!-- Delete sections you don't need — shorter is better -->

## Project

[PROJECT_NAME] — [one-line description of what this project does].

- **Stack**: [e.g., Next.js 15 + Tailwind v4 + Supabase + Stripe]
- **Language**: [e.g., TypeScript strict mode]
- **Package manager**: [npm | pnpm | bun | yarn]
- **Node version**: [e.g., 22.x]

## Code Standards

### Style
- [e.g., Use Tailwind utility classes, never write custom CSS unless Tailwind can't express it]
- [e.g., Functional components with hooks, no class components]
- [e.g., Named exports only, no default exports except pages]
- [e.g., Prefer const arrow functions for components]

### Naming
- Components: PascalCase (`UserProfile.tsx`)
- Utilities: camelCase (`formatDate.ts`)
- Constants: SCREAMING_SNAKE (`MAX_RETRIES`)
- Files: kebab-case for non-component files (`api-client.ts`)
- Database columns: snake_case (`created_at`)

### Architecture
- [e.g., Feature-based directory structure: `src/features/[feature]/`]
- [e.g., Server actions for mutations, RSC for data fetching]
- [e.g., Zod schemas co-located with their API routes]
- [e.g., All database queries go through `src/lib/db.ts`, never direct SQL in components]

## File Structure

```
src/
  app/              # Pages and layouts (Next.js App Router)
  components/       # Shared UI components
    ui/             # Base primitives (Button, Input, Card)
  features/         # Feature modules (auth, billing, dashboard)
    [feature]/
      components/   # Feature-specific components
      hooks/        # Feature-specific hooks
      actions.ts    # Server actions
      queries.ts    # Data fetching
  lib/              # Shared utilities
    db.ts           # Database client
    auth.ts         # Auth helpers
    utils.ts        # General utilities
```

## Git Workflow

- All work on `dev` branch, never commit directly to `main`
- Conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`
- Commit after each logical change, push frequently
- Run `[BUILD_COMMAND]` before any merge to main
- Ask before merging to main or deploying

## Security

- Never hardcode secrets — use environment variables
- `.env` files are in `.gitignore`
- Validate all user input at system boundaries (API routes, form handlers)
- Use parameterized queries, never string concatenation for SQL
- Sanitize HTML output to prevent XSS

## Testing

- [e.g., Vitest for unit tests, Playwright for E2E]
- Run `[TEST_COMMAND]` after significant changes
- Test the happy path and one error case minimum
- Don't write tests unless asked or the change is risky

## Deployment

- **Platform**: [e.g., Vercel | Cloudflare Pages | Railway]
- **Deploy command**: [e.g., `vercel --prod` | `npm run deploy`]
- **Environment**: Production secrets are set in [platform dashboard]
- Always build locally before deploying: `[BUILD_COMMAND]`
- Run pending database migrations after deploy

## Communication

- Be direct — no filler, no over-explaining
- After changes, briefly explain what changed and why
- If something breaks, fix it — don't just describe what went wrong
- If a fix fails twice, stop and ask rather than looping

## What NOT To Do

- Don't add features, refactoring, or "improvements" beyond what was asked
- Don't create files unless necessary — prefer editing existing files
- Don't add comments to code you didn't change
- Don't add error handling for impossible scenarios
- Don't create abstractions for one-time operations
- Read a file before editing it — no exceptions
