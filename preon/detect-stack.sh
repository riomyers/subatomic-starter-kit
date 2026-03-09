#!/bin/bash
# detect-stack.sh — Framework/language detection engine
# Preon Project Bootstrapper — https://subatomic.pro
set -euo pipefail

TARGET="${1:-.}"

detect() {
  local framework="unknown"
  local language="unknown"
  local package_manager="unknown"
  local has_docker=false
  local has_ci=false
  local is_monorepo=false

  # Monorepo detection (check first — overrides framework)
  if [ -f "$TARGET/turbo.json" ] || [ -f "$TARGET/nx.json" ] || [ -f "$TARGET/lerna.json" ]; then
    framework="monorepo"
    is_monorepo=true
  fi

  # Language detection
  if [ -f "$TARGET/package.json" ]; then
    language="javascript"
    if [ -f "$TARGET/package-lock.json" ]; then package_manager="npm"
    elif [ -f "$TARGET/yarn.lock" ]; then package_manager="yarn"
    elif [ -f "$TARGET/pnpm-lock.yaml" ]; then package_manager="pnpm"
    elif [ -f "$TARGET/bun.lockb" ]; then package_manager="bun"
    fi

    # Framework detection from package.json
    if [ "$framework" = "unknown" ]; then
      if ls "$TARGET"/next.config.* 2>/dev/null | grep -q .; then
        framework="nextjs"
      elif ls "$TARGET"/vite.config.* 2>/dev/null | grep -q .; then
        framework="react-vite"
      elif ls "$TARGET"/nuxt.config.* 2>/dev/null | grep -q .; then
        framework="nuxt"
      elif ls "$TARGET"/svelte.config.* 2>/dev/null | grep -q .; then
        framework="sveltekit"
      elif grep -q '"express"' "$TARGET/package.json" 2>/dev/null; then
        framework="node-express"
      else
        framework="node"
      fi
    fi

    # TypeScript detection
    if [ -f "$TARGET/tsconfig.json" ]; then
      language="typescript"
    fi

  elif [ -f "$TARGET/requirements.txt" ] || [ -f "$TARGET/pyproject.toml" ] || [ -f "$TARGET/setup.py" ]; then
    language="python"
    if [ -f "$TARGET/requirements.txt" ]; then package_manager="pip"
    elif [ -f "$TARGET/pyproject.toml" ]; then package_manager="poetry"
    fi

    if [ -f "$TARGET/manage.py" ]; then
      framework="django"
    elif grep -q "fastapi" "$TARGET/requirements.txt" 2>/dev/null || grep -q "fastapi" "$TARGET/pyproject.toml" 2>/dev/null; then
      framework="fastapi"
    elif grep -q "flask" "$TARGET/requirements.txt" 2>/dev/null; then
      framework="flask"
    else
      framework="python"
    fi

  elif [ -f "$TARGET/go.mod" ]; then
    language="go"
    framework="go"
    package_manager="go-mod"

  elif [ -f "$TARGET/Gemfile" ]; then
    language="ruby"
    package_manager="bundler"
    if grep -q "rails" "$TARGET/Gemfile" 2>/dev/null; then
      framework="rails"
    else
      framework="ruby"
    fi

  elif [ -f "$TARGET/Cargo.toml" ]; then
    language="rust"
    framework="rust"
    package_manager="cargo"

  elif [ -f "$TARGET/index.html" ]; then
    language="html"
    framework="static-site"
  fi

  # Docker detection
  [ -f "$TARGET/Dockerfile" ] || [ -f "$TARGET/docker-compose.yml" ] && has_docker=true

  # CI detection
  [ -d "$TARGET/.github/workflows" ] || [ -f "$TARGET/.gitlab-ci.yml" ] && has_ci=true

  # Output as parseable key=value
  echo "FRAMEWORK=$framework"
  echo "LANGUAGE=$language"
  echo "PACKAGE_MANAGER=$package_manager"
  echo "HAS_DOCKER=$has_docker"
  echo "HAS_CI=$has_ci"
  echo "IS_MONOREPO=$is_monorepo"
}

detect
