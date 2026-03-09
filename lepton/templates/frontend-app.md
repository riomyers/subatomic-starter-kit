# CLAUDE.md — Frontend Application

<!-- Lepton Template: Frontend App v1.0 -->
<!-- Optimized for React/Vue/Svelte SPAs and SSR apps -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description].

- **Framework**: [e.g., Next.js 15 (App Router) | Vite + React 19 | Nuxt 4 | SvelteKit 2]
- **UI**: [e.g., Tailwind v4 + shadcn/ui | Chakra UI | Styled Components]
- **State**: [e.g., Zustand | Jotai | React Context | Pinia]
- **Language**: TypeScript (strict mode)
- **Package manager**: [npm | pnpm | bun]
- **Node**: [e.g., 22.x]

## Code Standards

### Components
- Functional components only — no class components
- One component per file, file named after the component
- Props defined with TypeScript interfaces, co-located above the component
- Keep components under 150 lines — extract sub-components when they grow
- Prefer composition over prop drilling — use context or state management for deep props (3+ levels)

### Styling
<!-- Choose one block, delete the others -->

<!-- Tailwind v4 -->
- Tailwind utility classes for all styling
- Never write custom CSS unless Tailwind genuinely can't express it
- Use `cn()` utility (clsx + tailwind-merge) for conditional classes
- Extract repeated utility patterns into components, not `@apply`
- Design tokens in `tailwind.config` — never hardcode colors or spacing values

<!-- CSS Modules -->
- CSS Modules for component styles (`.module.css`)
- BEM naming within modules: `block__element--modifier`
- Global styles only in `globals.css` for resets and CSS custom properties

### Data Fetching
<!-- Choose one block -->

<!-- Next.js App Router -->
- Server Components for data fetching — no `useEffect` for initial data
- Server Actions for mutations — forms POST to server actions
- `use()` hook for consuming promises in client components
- Cache with `unstable_cache` or `fetch` cache options, not client-side state

<!-- SPA / Vite -->
- [e.g., TanStack Query for all async state — no raw useEffect + useState]
- Queries in `src/features/[feature]/queries.ts`
- Mutations in `src/features/[feature]/mutations.ts`
- Loading and error states handled at the query level, not per-component

### Forms
- [e.g., React Hook Form + Zod | Formik + Yup | native form actions]
- Validation schemas co-located with the form component
- Client-side validation mirrors server-side validation — same Zod schema shared
- Show inline field errors, not alert dialogs
- Disable submit button during submission, show loading state

### Routing
<!-- Choose one -->
- [Next.js] File-based routing in `app/` directory. Dynamic routes use `[slug]` convention
- [React Router] Routes defined in `src/routes.tsx`. Lazy-load page components
- [SvelteKit] File-based routing in `src/routes/`. Form actions for mutations

## File Structure

```
src/
  app/                  # Pages, layouts, route handlers (Next.js)
  components/
    ui/                 # Base primitives: Button, Input, Card, Dialog
    layout/             # Shell, Sidebar, Header, Footer
    [feature]/          # Feature-scoped components
  features/
    auth/               # Login, signup, session management
    [feature]/
      components/       # UI specific to this feature
      hooks/            # Custom hooks for this feature
      queries.ts        # Data fetching
      actions.ts        # Mutations / server actions
      types.ts          # Feature-specific types
  hooks/                # Shared custom hooks
  lib/
    api.ts              # API client / fetch wrapper
    utils.ts            # General utilities (cn, formatDate, etc.)
    constants.ts        # App-wide constants
  types/                # Shared TypeScript types
  styles/               # Global styles, theme tokens
```

## Visual & UX Rules

- Mobile-first responsive design — start with mobile, add `md:` / `lg:` breakpoints
- Every interactive element needs: default, hover, focus, active, disabled states
- Loading states for all async operations — skeleton loaders preferred over spinners
- Error states show actionable messages, not raw error text
- Navigation: users should never feel stuck — always a visible path back
- Animations: subtle and purposeful. No animation > bad animation.
- Accessibility: semantic HTML, ARIA labels on icon-only buttons, keyboard navigation works

## Performance

- Images: Use `<Image>` component (Next.js) or `loading="lazy"` + explicit dimensions
- Fonts: Subset and preload. System font stack as fallback
- Bundle: Dynamic imports for routes and heavy components (`lazy()` / `dynamic()`)
- No layout shift: Reserve space for async content with skeletons or fixed dimensions
- Lighthouse target: Performance > 90, Accessibility > 95

## Git Workflow

- Work on `dev` branch, merge to `main` for releases
- Conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `style:`
- Run `[BUILD_COMMAND]` before any merge — TypeScript errors break the build
- Run `[LINT_COMMAND]` to catch style issues

## Security

- Never render raw user content — sanitize HTML or use framework escaping
- API keys in environment variables, never in client-side code
- Auth tokens in httpOnly cookies, not localStorage
- CORS configured on the API, not disabled
- CSP headers configured for production

## Communication

- After UI changes, describe what changed visually
- Reference component names and file paths in explanations
- If a design decision is ambiguous, ask — don't guess
- Keep UI text concise — buttons are verbs ("Save", "Delete"), not descriptions
