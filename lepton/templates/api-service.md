# CLAUDE.md — API Service

<!-- Lepton Template: API Service v1.0 -->
<!-- For REST APIs, GraphQL services, and backend microservices -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description of the API].

- **Runtime**: [e.g., Node.js 22 | Bun 1.2 | Deno 2 | Python 3.13 | Go 1.23]
- **Framework**: [e.g., Express | Fastify | Hono | FastAPI | Gin]
- **Database**: [e.g., PostgreSQL 17 via Supabase | MySQL 8 | SQLite via D1]
- **ORM/Query**: [e.g., Drizzle | Prisma | Knex | raw SQL | SQLAlchemy]
- **Auth**: [e.g., JWT | Session cookies | OAuth2 | API keys]
- **Package manager**: [npm | pnpm | pip | go mod]

## API Design

### REST Conventions
- Resource URLs are plural nouns: `/api/users`, `/api/orders`
- Use HTTP verbs correctly: GET (read), POST (create), PUT (full update), PATCH (partial update), DELETE
- Nested resources max 2 levels deep: `/api/users/:id/orders` (not `/api/users/:id/orders/:oid/items/:iid`)
- Query params for filtering/sorting/pagination: `?status=active&sort=-created_at&page=2&limit=20`
- Response format: `{ "data": [...], "meta": { "total": 100, "page": 2 } }` for lists
- Error format: `{ "error": { "code": "VALIDATION_ERROR", "message": "Email is required", "details": [...] } }`

### Status Codes
- 200: Success (GET, PUT, PATCH)
- 201: Created (POST)
- 204: No Content (DELETE)
- 400: Bad Request (validation failure)
- 401: Unauthorized (no auth / expired token)
- 403: Forbidden (authenticated but not allowed)
- 404: Not Found
- 409: Conflict (duplicate resource)
- 422: Unprocessable Entity (valid syntax, invalid semantics)
- 429: Rate Limited
- 500: Internal Server Error (never leak stack traces)

### Validation
- Validate all input at the route handler level — before it reaches business logic
- Use [e.g., Zod | Joi | Pydantic | validator] for schema validation
- Validation schemas co-located with their route handler
- Return specific field errors: `{ "details": [{ "field": "email", "message": "must be a valid email" }] }`
- Never trust client data — validate even if the frontend "already validated"

## Code Standards

### Architecture
```
src/
  routes/              # Route handlers (thin — validate, call service, respond)
    users.ts
    orders.ts
  services/            # Business logic (pure functions where possible)
    user-service.ts
    order-service.ts
  db/                  # Database access layer
    queries/           # Raw queries or ORM calls
    migrations/        # Schema migrations (sequential, timestamped)
    schema.ts          # Table definitions / Drizzle schema
  middleware/          # Auth, logging, rate limiting, error handling
  lib/                 # Shared utilities
    errors.ts          # Custom error classes
    logger.ts          # Structured logging
    config.ts          # Environment config (validated at startup)
  types/               # Shared TypeScript types
```

### Layering Rules
- **Routes** call **services**, services call **db** — never skip layers
- Routes handle HTTP concerns (request parsing, response formatting, status codes)
- Services handle business logic (rules, calculations, orchestration) — no HTTP awareness
- DB layer handles persistence (queries, transactions) — no business logic
- Cross-cutting concerns (auth, logging, errors) live in middleware

### Error Handling
- Custom error classes extend a base `AppError` with `statusCode` and `code` properties
- Route handlers catch service errors and map to HTTP responses
- Unexpected errors return 500 with a generic message — log the full error server-side
- Never expose stack traces, SQL errors, or internal paths in API responses
- Use a global error handler middleware as the last safety net

### Database
- All schema changes via migrations — never modify the database manually in production
- Migrations are sequential and idempotent: `001_create_users.sql`, `002_add_orders.sql`
- Use transactions for multi-table writes
- Index columns used in WHERE, JOIN, and ORDER BY clauses
- Use parameterized queries — NEVER concatenate user input into SQL strings
- Soft delete with `deleted_at` timestamp when business logic requires it

## Security

### Authentication
- [e.g., JWT in httpOnly cookies | Bearer token in Authorization header | API key in X-API-Key header]
- Token expiry: access tokens 15min, refresh tokens 7d
- Auth middleware runs on all routes except explicitly public ones
- Rate limit auth endpoints aggressively (5 attempts / 15min per IP)

### Data Protection
- Hash passwords with bcrypt (cost 12) or argon2 — never store plaintext
- Encrypt sensitive data at rest (PII, payment info, API keys)
- Log request metadata but NEVER log: passwords, tokens, credit card numbers, personal data
- Sanitize all output — even internal services can have injection vectors in logging

### Input Sanitization
- Parameterized queries for ALL database operations
- Escape HTML in any user content that might be rendered
- Validate file uploads: check MIME type, enforce size limits, scan for malware
- Validate URL parameters and path segments — don't assume they're safe because they're "not user input"

## Testing

- [e.g., Vitest | Jest | pytest | go test] for unit and integration tests
- Test the API contract (status codes, response shape), not implementation details
- Integration tests use a test database — seed before, clean after
- Test auth flows: valid token, expired token, no token, wrong permissions
- Test validation: valid input, missing fields, wrong types, boundary values
- Run `[TEST_COMMAND]` before merging

## Deployment

- **Platform**: [e.g., Railway | Render | AWS ECS | Cloudflare Workers | Fly.io]
- **Deploy command**: [e.g., `railway up` | `fly deploy`]
- Run database migrations as part of deploy (or immediately after)
- Health check endpoint at `GET /api/health` — returns 200 + service status
- Environment variables set in [platform dashboard] — never in code or Docker images

## Logging & Monitoring

- Structured JSON logging: `{ "level": "info", "msg": "user_created", "userId": "..." }`
- Log levels: error (failures), warn (recoverable issues), info (significant events), debug (development only)
- Request logging middleware: method, path, status, duration
- Never log at debug level in production
- [e.g., Monitor with Sentry for errors, PostHog for analytics]

## Communication

- Reference HTTP methods and paths in explanations: "the `POST /api/orders` endpoint"
- After API changes, describe the request/response contract
- If changing a public API, flag breaking changes explicitly
- After adding routes, update the API documentation or route listing
