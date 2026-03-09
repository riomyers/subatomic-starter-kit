# CLAUDE.md — Monorepo

<!-- Lepton Template: Monorepo v1.0 -->
<!-- For Turborepo, Nx, pnpm workspaces, and npm workspaces -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description].

- **Monorepo tool**: [e.g., Turborepo | Nx | pnpm workspaces | npm workspaces]
- **Language**: [e.g., TypeScript strict mode across all packages]
- **Package manager**: [pnpm | npm | yarn] (monorepos strongly prefer pnpm)
- **Node**: [e.g., 22.x]

## Workspace Structure

```
[PROJECT_NAME]/
  apps/
    web/               # Customer-facing frontend
    admin/             # Internal admin dashboard
    api/               # Backend API service
    docs/              # Documentation site
  packages/
    ui/                # Shared component library
    db/                # Database schema, client, migrations
    config/            # Shared configs (ESLint, TypeScript, Tailwind)
    utils/             # Shared utilities (formatting, validation)
    types/             # Shared TypeScript type definitions
  tooling/
    eslint/            # ESLint config package
    typescript/        # tsconfig base presets
  turbo.json           # Pipeline configuration
  pnpm-workspace.yaml  # Workspace definition
```

## Monorepo Rules

### Package Boundaries
- Every `packages/*` and `apps/*` directory is a separate package with its own `package.json`
- Packages import each other by name (`@[scope]/ui`), never by relative path (`../../packages/ui`)
- Internal packages use `"workspace:*"` version in `package.json` dependencies
- Each package defines its public API in `src/index.ts` — internal modules are private

### Dependency Management
- **Shared deps** (React, TypeScript) go in the root `package.json`
- **Package-specific deps** go in that package's `package.json`
- **Never duplicate versions** — if two packages need `zod`, put it in root or ensure versions match
- Run `[INSTALL_COMMAND]` from the root — never from inside a package
- When adding a dep to a package: `pnpm add zod --filter @[scope]/api`

### Building
- `turbo run build` builds all packages in dependency order
- Build cache is enabled — only rebuilds what changed
- Each package has its own `build` script in `package.json`
- When changing a shared package (`packages/ui`), Turbo automatically rebuilds dependent apps
- Don't try to build individual apps without building their dependencies first

### Task Pipeline
```jsonc
// turbo.json — defines task dependency graph
{
  "tasks": {
    "build": { "dependsOn": ["^build"] },
    "test": { "dependsOn": ["build"] },
    "lint": {},
    "dev": { "cache": false, "persistent": true }
  }
}
```

## Code Standards

### Shared Packages
- `packages/ui` — Design system components with Storybook (if applicable)
- `packages/db` — Single source of truth for database schema and queries
- `packages/types` — Shared TypeScript types used across 2+ packages
- `packages/utils` — General utilities (date formatting, string helpers, validators)
- `packages/config` — Base configs extended by each app (tsconfig, eslint, tailwind)

### Creating New Packages
1. Create directory in `packages/` or `apps/`
2. Add `package.json` with `"name": "@[scope]/[name]"`
3. Add `tsconfig.json` extending base config: `{ "extends": "@[scope]/typescript/base" }`
4. Add to workspace definition if needed
5. Add build/lint/test scripts
6. Export public API from `src/index.ts`

### When to Extract to a Shared Package
- Used by 2+ apps/packages — extract
- Used by 1 app — keep it in the app
- Utility function used everywhere — `packages/utils`
- UI component used in multiple apps — `packages/ui`
- Type used across boundaries — `packages/types`
- Don't preemptively extract — wait for the second use

## File Navigation

When working in a monorepo, always clarify which package/app you're working in:
- "In `apps/web`..." or "In `packages/ui`..."
- File paths should be relative to the package root, not the monorepo root
- When changing shared packages, list all dependent apps that may be affected
- Run `turbo run build --filter=@[scope]/[affected-package]...` to test impact

## Git Workflow

- Same branch strategy as your team uses
- Conventional commits with scope = package: `feat(web): add user profile page`
- When a change spans multiple packages, use the primary affected package as scope
- Lock file changes (`pnpm-lock.yaml`) in their own commit — they create noisy diffs
- CI runs the full pipeline: `turbo run lint build test`

## Development

### Starting Local Dev
```bash
# All apps
[e.g., turbo run dev]

# Specific app
[e.g., turbo run dev --filter=@scope/web]

# Specific app + its dependencies
[e.g., turbo run dev --filter=@scope/web...]
```

### Common Tasks
- Add dependency to a package: `pnpm add [pkg] --filter @[scope]/[name]`
- Add workspace dependency: `pnpm add @[scope]/utils --filter @[scope]/web --workspace`
- Run script in one package: `turbo run test --filter=@[scope]/api`
- Clean all build outputs: `turbo run clean`

## Deployment

- Each app deploys independently — `apps/web` and `apps/api` may have different deploy targets
- Shared package changes trigger rebuilds of dependent apps (via Turbo or CI detect)
- **Web**: [e.g., Vercel with root directory set to `apps/web`]
- **API**: [e.g., Railway with root directory set to `apps/api`]
- **Docs**: [e.g., Cloudflare Pages with root directory set to `apps/docs`]
- Build before deploy: `turbo run build --filter=@[scope]/[app]...`

## Communication

- Always specify which package/app you're discussing
- After changes to shared packages, list which apps are affected
- Reference paths as `apps/web/src/...` or `packages/ui/src/...` — full paths from monorepo root
- When debugging, identify if the issue is in the app or a shared package
