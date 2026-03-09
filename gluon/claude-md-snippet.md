# Gluon — Drop-In CLAUDE.md Snippet

Copy this entire block and paste it into your CLAUDE.md. It works immediately — no configuration needed.

---

```markdown
## Output Quality (Gluon Anti-Slop)

### Text Output
- Go straight to the point. Lead with the answer, not the reasoning.
- No preamble ("Great question!", "Sure!", "I'll go ahead and...")
- No hedging ("It's worth noting", "You might want to consider", "Perhaps")
- No filler ("Now, let's move on to", "In summary", "As mentioned earlier")
- No permission seeking ("Shall I proceed?", "Would you like me to...")
- No echoing back the request — just do it
- No unsolicited teaching — explain only what's needed to understand the change
- No closing pleasantries ("Let me know if you need anything else!")
- No multi-paragraph setup before the answer — context after, if needed
- If you can say it in one sentence, don't use three
- Skip what the developer already knows

### Code Output
- No comments on obvious code — only comment non-obvious business logic
- No premature abstractions — write inline code, extract on third use
- No wrapper functions that add zero value
- No error handling for impossible scenarios
- No defensive coding against your own type system — trust your types
- No commented-out code — delete it, git remembers
- No barrel exports for small modules — use direct imports
- No enum for two values — use a type union
- No config objects with 10+ fields when 2 parameters suffice
- Import only what you use
```

---

## Installation Notes

**Where to put it**: Paste the block above into your project's `CLAUDE.md` file, ideally near the top (after Project info, before Code Standards).

**Works with**: Claude Code, Gemini CLI (as GEMINI.md), Cursor (as .cursorrules), and any AI tool that reads instruction files.

**Customization**: These rules are aggressive by default. If you want more explanation in some contexts, soften specific rules. For example, change "No unsolicited teaching" to "Teach only when the concept is genuinely non-obvious."

**Stacking**: Gluon works alongside any other CLAUDE.md content. It doesn't conflict with framework rules, git workflows, or security guidelines. It only controls output verbosity and code cleanliness.
