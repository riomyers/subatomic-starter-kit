# CLAUDE.md — React + Vite Project

## Stack
- **Framework**: React with Vite
- **Language**: TypeScript / JavaScript
- **Styling**: CSS Modules / Tailwind
- **Deploy**: Cloudflare Pages / Vercel / Netlify

## Commands
- `npm run dev` — Start dev server (Vite HMR)
- `npm run build` — Production build
- `npm run preview` — Preview production build locally
- `npm run lint` — ESLint check

## Code Standards
- Functional components only — no class components
- Custom hooks in `src/hooks/` for shared logic
- State management: React Context for simple, Zustand for complex
- Use `React.lazy()` + `Suspense` for code splitting
- CSS Modules: `Component.module.css` co-located with component
- Never manipulate DOM directly — use refs only when absolutely necessary

## File Structure
- `src/components/` — Reusable UI components
- `src/pages/` — Route-level components
- `src/hooks/` — Custom hooks
- `src/lib/` — Utilities, API clients, helpers
- `src/data/` — Static data, constants
- `public/` — Static assets (fonts, images)

## Rules
- Keep components under 150 lines — extract sub-components when larger
- Props interface defined inline or in same file, not separate types file
- Use `key` prop correctly in lists — never use array index for dynamic lists
- Handle loading and error states for every async operation
- `npm run build` must pass before committing
