# CLAUDE.md — Team Project

<!-- Lepton Template: Team Project v1.0 -->
<!-- For shared repositories with multiple developers using Claude Code -->
<!-- Replace all [BRACKETS] with your project specifics -->
<!-- NOTE: This goes in your project root, NOT in personal CLAUDE.md -->

## Project

[PROJECT_NAME] — [one-line description].

- **Stack**: [e.g., Next.js 15 + PostgreSQL + Redis + Stripe]
- **Language**: [e.g., TypeScript strict mode]
- **Package manager**: [npm | pnpm]
- **Required tools**: [e.g., Docker for local dev, Node 22.x, pnpm 9.x]

## Team Conventions

### Ownership
- Each feature directory has an OWNERS comment in its index file
- Before modifying shared code (`src/lib/`, `src/components/ui/`), check if changes affect other features
- When touching another team's feature code, keep changes minimal and document why

### Code Review Standards
- All changes go through PR review — no direct pushes to `main` or `dev`
- PRs should be reviewable in <15 minutes — split large changes into stacked PRs
- Every PR needs: description of what changed, why, and how to test it
- Screenshots for UI changes, curl examples for API changes

### Shared Code Rules
- `src/lib/` is shared infrastructure — changes here affect everyone
- New shared utilities need a clear use case in 2+ features before extraction
- Don't add dependencies without team discussion — check if an existing dep covers the need
- Lock file (`package-lock.json` / `pnpm-lock.yaml`) changes always go in their own commit

## Code Standards

### TypeScript
- Strict mode enabled — no `any` types except in verified migration code with `// @ts-expect-error` comment explaining why
- Shared types in `src/types/` — feature-specific types co-located with the feature
- Use discriminated unions over optional fields when modeling state
- Prefer `unknown` + type narrowing over `any` for dynamic data

### Architecture
```
src/
  app/                # Routes/pages — thin, mostly layout + data wiring
  components/
    ui/               # Shared primitives (Button, Input, Modal) — team-reviewed changes only
    layout/           # App shell, navigation, shared layout
  features/
    [feature-name]/   # Self-contained feature module
      components/     # Feature-specific UI
      hooks/          # Feature-specific hooks
      services/       # Business logic
      types.ts        # Feature-specific types
      index.ts        # Public API — only export what other features need
  lib/                # Shared utilities — changes affect all features
    api/              # API client, fetch wrapper
    auth/             # Auth context, guards, helpers
    db/               # Database client, query helpers
    utils/            # General utilities (format, validate, etc.)
  types/              # Shared TypeScript types
  config/             # App configuration, feature flags
```

### Feature Module Rules
- Features don't import from other features directly — use shared lib or events
- Each feature's `index.ts` defines its public API — internal modules are private
- Feature-specific routes, components, hooks, and services stay in the feature directory
- When a pattern is used in 3+ features, extract to `lib/` via PR

### Database
- All schema changes via sequential migrations: `migrations/NNNN_description.sql`
- Never modify existing migrations — create new ones
- Migrations reviewed with extra scrutiny — they affect production data
- Use transactions for multi-table writes
- Add indexes for new query patterns — check query plans for slow queries

## Git Workflow

- **Branches**: `main` (production) ← `dev` (integration) ← `feature/[ticket-id]-description`
- **Commits**: Conventional commits with ticket reference: `feat(auth): add SSO login [PROJ-123]`
- **Merge strategy**: Squash merge to dev, merge commit to main
- **Before PR**: Run `[BUILD_COMMAND]` and `[TEST_COMMAND]` locally
- **Conflict resolution**: Rebase feature branch on dev before PR, resolve conflicts in the feature branch
- **Protected branches**: `main` and `dev` require PR approval + passing CI

## Environment & Setup

### Local Development
```bash
# First time setup
[e.g., cp .env.example .env.local]
[e.g., docker compose up -d]
[e.g., pnpm install]
[e.g., pnpm db:migrate]
[e.g., pnpm dev]
```

### Environment Variables
- `.env.example` is committed — keeps the template up to date
- `.env.local` is gitignored — each developer manages their own
- When adding a new env var: update `.env.example`, update README, notify the team
- Production env vars managed in [e.g., Vercel dashboard | Railway | AWS SSM]
- Required vars are validated at startup — the app crashes with a clear error if missing

## Testing

- **Unit tests**: Pure functions, utilities, business logic (fast, no I/O)
- **Integration tests**: API routes, database queries (use test database)
- **E2E tests**: Critical user flows only (login → dashboard → key action)
- Run `[TEST_COMMAND]` before every PR — CI blocks merge on failure
- New features need at least happy-path tests
- Bug fixes need a regression test proving the fix works

## Security

- Environment variables for all secrets — enforced by CI secret scanning
- Auth middleware on all non-public routes — whitelist public routes explicitly
- Input validation at every system boundary (API handlers, form processors, webhook receivers)
- SQL injection prevention: parameterized queries only
- XSS prevention: framework escaping + CSP headers
- CSRF: tokens for state-changing operations or SameSite cookies
- Dependencies: Renovate/Dependabot enabled, security updates merged within 48h

## Deployment

- **CI/CD**: [e.g., GitHub Actions | GitLab CI | CircleCI]
- **Pipeline**: lint → type-check → test → build → deploy
- **Environments**: dev (auto-deploy from `dev` branch), staging (manual), production (merge to `main`)
- **Rollback**: [e.g., `vercel rollback` | `railway rollback` | revert commit on main]
- **Database migrations**: Run automatically during deploy (migration runner in startup script)
- **Feature flags**: [e.g., PostHog | LaunchDarkly | env var based] — gate incomplete features behind flags

## Communication

- Reference file paths and line numbers when discussing code
- After changes, list: what files changed, what the change does, how to verify
- Flag if a change requires: migration, env var update, dependency install, or team notification
- Don't refactor code you're not actively working on — make a separate ticket
- If you disagree with an existing pattern, flag it but follow the existing pattern for consistency
