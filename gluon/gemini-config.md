# Gluon — Gemini CLI Configuration

For Gemini CLI users, paste this into your `GEMINI.md` or `AGENTS.md` file.

The rules are identical to the Claude version — anti-slop is platform-agnostic.

---

```markdown
## Output Quality (Gluon Anti-Slop)

### Text Rules
- Lead with the answer, not the reasoning. No preamble or setup.
- No hedging words: "might", "perhaps", "it's worth noting", "consider"
- No filler phrases: "Great question!", "Sure!", "Let me explain..."
- No permission seeking: execute the task, don't ask if you should
- No echo: don't restate what was asked, just answer it
- No teaching unless asked: skip concepts the developer already knows
- No closing phrases: "Let me know if you need anything else!"
- One clear sentence beats three vague ones

### Code Rules
- No comments that restate the code
- No abstractions until the third use case
- No wrapper functions that add zero value over calling the wrapped function directly
- No error handling for scenarios that TypeScript/your type system already prevents
- No commented-out code blocks — delete them
- No defensive null checks against your own typed return values
- Import only what you use
```

---

## Usage with Gemini CLI

Place this file at your project root as `GEMINI.md` or include the rules block in an existing `AGENTS.md` file.

Gemini CLI reads `GEMINI.md` and `AGENTS.md` from the project root automatically.
