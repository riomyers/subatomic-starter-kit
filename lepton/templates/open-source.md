# CLAUDE.md — Open Source Project

<!-- Lepton Template: Open Source v1.0 -->
<!-- For public repos with external contributors using AI tools -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description].

- **Language**: [e.g., TypeScript | Python | Rust | Go]
- **License**: [e.g., MIT | Apache 2.0 | GPL-3.0]
- **Status**: [e.g., Alpha | Beta | Stable | Maintenance mode]
- **Docs**: [e.g., docs.example.com | README + examples/]

## Contributor Guidelines

### For AI Assistants Working on This Repo
- Read CONTRIBUTING.md before making changes — it has the human-readable version of these rules
- Follow existing patterns in the codebase — consistency over personal preference
- New features need an issue or RFC approved before implementation
- Bug fixes can go straight to PR with a reproduction case
- Don't refactor while fixing bugs — separate PRs for separate concerns

### Code Ownership
- Core maintainers review all PRs — don't merge without approval
- `src/core/` is high-risk: changes require 2+ reviewer approvals
- Plugin/extension APIs have stability guarantees — don't break them without major version bump
- Docs changes can be fast-tracked (single reviewer)

## Code Standards

### Style
- [e.g., Prettier + ESLint | Black + Ruff | rustfmt + clippy | gofmt]
- Pre-commit hooks enforce formatting — code that doesn't pass lint doesn't merge
- Run `[LINT_COMMAND]` before committing
- Follow [e.g., Standard JS | PEP 8 | Rust API Guidelines | Effective Go]

### API Design
- Public APIs are versioned — breaking changes only in major versions
- Deprecation cycle: deprecate with warning in minor version, remove in next major
- Every public function/method/class has documentation (JSDoc/docstring/rustdoc/godoc)
- Types are part of the API — exported types are a compatibility contract
- Error types are explicit — don't return generic errors, define specific error kinds

### Documentation
- Every public API has inline documentation explaining: what, parameters, returns, throws, example
- CHANGELOG.md updated with every PR (Keep a Changelog format)
- README sections: What, Install, Quick Start, Documentation, Contributing, License
- Examples in `examples/` directory — runnable, not pseudo-code
- Migration guides for breaking changes in `docs/migration/`

### Dependencies
- Minimize external dependencies — every dependency is a supply chain risk
- Vet new dependencies: maintenance status, bundle size, license compatibility, security history
- Pin exact versions in lockfile, use ranges in package.json/Cargo.toml
- `dependabot.yml` or `renovate.json` for automated security updates
- Audit dependencies before releases: `npm audit` / `cargo audit` / `pip audit`

## File Structure

```
[PROJECT_NAME]/
  src/                  # Source code
    core/               # Core logic — stability critical
    plugins/            # Plugin system / extensions
    utils/              # Internal utilities
    types/              # Public type definitions
    index.ts            # Main entry point — public API surface
  tests/                # Test files mirror src/ structure
  examples/             # Runnable example projects
  docs/                 # Documentation source
    api/                # API reference
    guides/             # How-to guides
    migration/          # Version migration guides
  benchmarks/           # Performance benchmarks (if applicable)
  scripts/              # Build, release, and maintenance scripts
  .github/
    ISSUE_TEMPLATE/     # Bug report, feature request templates
    PULL_REQUEST_TEMPLATE.md
    workflows/          # CI/CD pipelines
  CHANGELOG.md          # Version history
  CONTRIBUTING.md       # Contributor guidelines
  LICENSE               # License file
```

## Testing

- **Unit tests**: Required for all public APIs and core logic
- **Integration tests**: Required for plugin system and I/O boundaries
- **Snapshot tests**: For serialization formats and API response shapes (if applicable)
- **Benchmarks**: Performance-sensitive code has benchmarks (tracked over time)
- Tests run in CI on every PR — must pass before merge
- Coverage target: [e.g., 80%] — don't game it, but don't let it drop
- Run `[TEST_COMMAND]` locally before pushing

## Release Process

1. Update version in [e.g., package.json | Cargo.toml | pyproject.toml]
2. Update CHANGELOG.md with all changes since last release
3. Create release PR: version bump + changelog → `main`
4. After merge: tag with `v[X.Y.Z]`, CI publishes to [e.g., npm | crates.io | PyPI]
5. Create GitHub Release with changelog excerpt
6. Announce in [e.g., Discord | Twitter | blog]

### Versioning (SemVer)
- **Major** (X.0.0): Breaking API changes — migration guide required
- **Minor** (0.X.0): New features, backward-compatible — changelog entry required
- **Patch** (0.0.X): Bug fixes, no API changes — changelog entry required

## Git Workflow

- **Branches**: `main` (stable releases) ← feature branches
- **Commits**: Conventional Commits format: `feat:`, `fix:`, `docs:`, `chore:`, `perf:`, `refactor:`
- **PRs**: Fill out the PR template completely. Link to issue. Include test plan.
- **Reviews**: Be constructive. Approve with suggestions or request changes with reasoning.
- **Merge**: Squash merge for feature branches. Merge commit for release branches.

## Security

- **Vulnerability reporting**: SECURITY.md with responsible disclosure instructions
- No secrets in code — not even example or test secrets (use placeholders)
- Validate all external input — the library is used by people you don't control
- Fuzz testing for parsers and serializers (if applicable)
- Signed releases (npm provenance, GPG-signed tags) when possible
- Security advisories published via GitHub Security Advisories

## Communication

- Write commit messages for future contributors — explain why, not just what
- PR descriptions link to issues and explain the approach chosen
- If rejecting a contribution approach, explain the architectural reasoning
- Reference specific lines and files when reviewing code
- Update documentation in the same PR as code changes
