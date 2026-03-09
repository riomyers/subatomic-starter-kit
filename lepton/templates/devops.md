# CLAUDE.md — DevOps & Infrastructure

<!-- Lepton Template: DevOps v1.0 -->
<!-- For infrastructure, CI/CD, platform engineering, and SRE -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description].

- **Cloud**: [e.g., AWS | GCP | Azure | Cloudflare | Multi-cloud]
- **IaC**: [e.g., Terraform | Pulumi | CDK | CloudFormation | Ansible]
- **Containers**: [e.g., Docker + Kubernetes | Docker Compose | ECS | Cloud Run]
- **CI/CD**: [e.g., GitHub Actions | GitLab CI | CircleCI | Jenkins]
- **Monitoring**: [e.g., Datadog | Grafana + Prometheus | CloudWatch | New Relic]

## Infrastructure Conventions

### IaC Rules
- **All infrastructure is code** — no manual console changes. If it's not in code, it doesn't exist
- State file is remote: [e.g., S3 + DynamoDB lock | GCS + state lock | Terraform Cloud]
- One module per logical resource group: `modules/networking`, `modules/database`, `modules/compute`
- Environment separation via workspaces or directory structure: `environments/dev/`, `environments/prod/`
- Tag everything: `project`, `environment`, `team`, `managed-by=terraform`

### Directory Structure
```
infrastructure/
  modules/
    networking/         # VPC, subnets, security groups, DNS
    compute/            # EC2, ECS, Lambda, Cloud Run
    database/           # RDS, DynamoDB, Redis, managed DBs
    storage/            # S3, GCS, R2 buckets
    monitoring/         # Alerts, dashboards, log groups
    iam/                # Roles, policies, service accounts
  environments/
    dev/
      main.tf           # Dev environment configuration
      terraform.tfvars  # Dev-specific variable values
    staging/
    prod/
  scripts/              # Operational scripts (backup, rotate, migrate)
  .github/workflows/    # CI/CD pipelines
```

### Naming Convention
- Resources: `[project]-[env]-[resource]-[qualifier]`
  - Example: `subatomic-prod-api-sg`, `subatomic-dev-db-primary`
- Variables: descriptive, no abbreviations: `database_instance_class` not `db_inst_cls`
- Outputs: `[resource]_[attribute]`: `database_endpoint`, `api_url`

## CI/CD Pipelines

### Pipeline Design
- Every push triggers: lint → test → build
- Merges to `main` trigger: lint → test → build → deploy to staging → smoke test → deploy to prod (with approval gate)
- Pipeline files are version-controlled — no pipeline config in CI/CD UI
- Build artifacts are immutable — same artifact deploys to staging and production
- Pipeline secrets in CI/CD secret store — never in pipeline files

### Deployment
- **Blue-green** or **rolling** deploys — never big-bang replacements
- Health checks must pass before routing traffic to new version
- Rollback is automated: if health checks fail, revert to previous version
- Database migrations run before application deployment
- Feature flags gate new functionality — deploy code without activating features

### Pipeline Standards
```yaml
# Pattern for a deployment pipeline stage:
# 1. Checkout code
# 2. Cache dependencies
# 3. Install dependencies
# 4. Run linters (fail fast)
# 5. Run tests (fail fast)
# 6. Build artifacts
# 7. Deploy to target
# 8. Run smoke tests
# 9. Notify on success/failure
```

## Docker

### Dockerfile Standards
- Use multi-stage builds — build stage separate from runtime stage
- Pin base image versions: `FROM node:22.14-alpine` not `FROM node:latest`
- Non-root user in runtime stage: `USER 1001`
- `.dockerignore` mirrors `.gitignore` plus: `node_modules`, `.git`, `*.md`, `test/`
- Order layers for cache efficiency: deps → build → copy runtime files
- HEALTHCHECK instruction defined in Dockerfile

### Compose
- `docker-compose.yml` for local development
- `docker-compose.prod.yml` for production overrides (if applicable)
- Named volumes for persistent data (databases)
- Networks isolate services appropriately
- Environment variables via `.env` file (gitignored) or secret management

## Security

### Access
- Least privilege everywhere — no `*:*` IAM policies
- Service accounts for applications, personal accounts for humans
- MFA required on all human accounts, especially cloud console access
- Rotate credentials on schedule — automate rotation where possible
- Audit trail: CloudTrail / Audit Logs enabled, alerts on suspicious activity

### Secrets
- Production secrets in [e.g., AWS Secrets Manager | GCP Secret Manager | Vault]
- Never in environment variables in Dockerfiles or compose files
- Secret rotation automated via [tool/service]
- Application reads secrets at runtime — never bakes them into images

### Network
- All services in private subnets — only load balancers are public-facing
- TLS everywhere — no unencrypted traffic, even internal
- Security groups/firewall rules are explicit: allow-list, not deny-list
- WAF on public endpoints
- VPN or bastion for administrative access

## Monitoring & Alerting

### Observability Stack
- **Metrics**: [e.g., Prometheus + Grafana | Datadog | CloudWatch]
- **Logs**: [e.g., ELK | CloudWatch Logs | Loki | Datadog Logs]
- **Traces**: [e.g., Jaeger | Datadog APM | AWS X-Ray]
- **Alerts**: PagerDuty / Opsgenie / Slack integration

### Alert Rules
- Alert on symptoms (high error rate, slow response), not causes (high CPU)
- Every alert must have a runbook: what it means, how to diagnose, how to fix
- Severity levels: P1 (revenue impact, pages), P2 (degraded, Slack), P3 (investigate next day)
- No alert fatigue — if an alert fires and is ignored 3 times, fix or delete it

### SLOs
- Define SLOs for each service: availability (99.9%), latency (p99 < 500ms), error rate (< 0.1%)
- Error budget: if SLO is violated, freeze new features until reliability is restored
- Dashboard per service showing SLO status

## Disaster Recovery

- **Backups**: Automated daily backups of databases, config, and state files
- **Recovery**: Documented recovery procedure tested quarterly
- **RTO**: [e.g., 1 hour] — time to recover from complete failure
- **RPO**: [e.g., 24 hours] — maximum acceptable data loss
- **Runbooks**: Step-by-step for common incidents in `docs/runbooks/`

## Communication

- Reference specific resources by their full name: `subatomic-prod-api-ecs-service`
- After infrastructure changes: what changed, what's affected, rollback plan
- Flag cost implications of infrastructure changes
- Distinguish between: configuration changes (safe), infrastructure changes (needs review), and destructive changes (needs approval)
- All destructive operations require explicit confirmation — delete, destroy, terminate
