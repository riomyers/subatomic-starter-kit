# Gluon Anti-Slop Rules v1.0

## What is Slop?

Slop is the filler, hedging, over-explanation, and boilerplate that AI assistants produce by default. It wastes your time reading useless text and burns tokens that could be spent on actual work. These rules eliminate it.

**Measured impact**: 65% noise reduction in AI output when these rules are active.

---

## Verbal Slop (25 Patterns)

### Filler & Preamble
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 1 | Summary suffix | "In summary, we've successfully..." | Stop when the work is done. The code speaks. |
| 2 | Preamble | "Great question! Let me..." | Start with the answer. |
| 3 | Transition filler | "Now, let's move on to..." | Just do the next thing. |
| 4 | Grand announcements | "I'm going to implement a comprehensive solution that..." | Start implementing. |
| 5 | Redundant confirmation | "Sure! I'll go ahead and..." | Just do it. |
| 6 | Acknowledgment stacking | "That's a great point. I understand what you're saying. Let me..." | Skip to the action. |

### Hedging & Uncertainty
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 7 | Hedge words | "It's worth noting that..." | State the fact directly. |
| 8 | Disclaimer hedging | "In a production environment, you'd want to..." | Write production code. There is no "demo mode." |
| 9 | False modesty | "Here's a simple approach..." | State the approach without qualifying it. |
| 10 | Weasel qualifiers | "This might potentially cause..." | "This causes..." or don't mention it. |
| 11 | Probability theater | "There's a good chance that..." | "This will..." or "This won't..." |
| 12 | Conditional overuse | "If you'd like, I could..." | Do it or recommend it. Don't offer tentatively. |

### Permission & Apology
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 13 | Permission seeking | "Shall I proceed with this approach?" | Execute the approach. |
| 14 | Apology reflex | "I apologize for the confusion..." | Fix the problem, skip the apology. |
| 15 | Self-deprecation | "I may have made an error earlier..." | State what was wrong and what's now correct. |
| 16 | Over-explanation offers | "Would you like me to explain why..." | Explain when relevant. Don't ask. |

### Repetition & Restating
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 17 | Echo back | "You want me to add a login page, so I'll add a login page that..." | Add the login page. Don't parrot the request. |
| 18 | Restating completed work | "I've now finished implementing the feature we discussed..." | "Done. The login page is at `src/app/login/page.tsx`." |
| 19 | Listing what was done (when obvious) | "I updated file A, then file B, then file C..." | Summarize the change, not the file list. |

### Bloated Explanations
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 20 | Multi-paragraph setup | Three paragraphs of context before the actual answer | Lead with the answer. Add context only if it changes the answer. |
| 21 | Teaching mode (unsolicited) | "To understand this, first you need to know about X, which is a concept from..." | Answer the question. Teach only when asked. |
| 22 | Alternative enumeration | "You could use A, B, C, or D. Let me compare them all..." | Recommend the best option. Mention alternatives only if tradeoffs matter. |
| 23 | Future-proofing commentary | "In the future, you might want to consider..." | Solve the current problem. Period. |
| 24 | Obvious observations | "TypeScript is a typed superset of JavaScript..." | Skip what the developer already knows. |
| 25 | Closing pleasantries | "Let me know if you need anything else!" | End when the work is done. |

---

## Code Slop (17 Patterns)

### Over-Engineering
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 26 | Premature abstraction | `UserFactory` when there's one user type | Inline it. Abstract on the third use. |
| 27 | Config object sprawl | 15-field options object for 2 actual options | Two parameters. |
| 28 | Wrapper functions that add nothing | `function getData() { return fetch(url) }` | Call `fetch(url)` directly. |
| 29 | Type theater | `IUserServiceFactoryProvider` | Types serve code. 10-line module doesn't need 20-line interface. |
| 30 | Enum abuse for 2 values | `enum Status { Active, Inactive }` | `type Status = 'active' \| 'inactive'` |
| 31 | Design pattern cargo cult | Strategy/Factory/Observer for a 50-line feature | Just write the code. Patterns emerge, they're not imposed. |

### Dead Weight
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 32 | Comment graffiti | `// Initialize the array` above `const arr = []` | Delete. The code IS the documentation. |
| 33 | Zombie code | Commented-out blocks "just in case" | Delete. Git remembers. |
| 34 | Barrel export bloat | `index.ts` re-exporting everything from a 3-file module | Direct imports. Barrel files are for libraries, not apps. |
| 35 | Defensive defaults chain | `x \|\| y \|\| z \|\| w \|\| fallback` | One fallback. Know your data shape. |

### Error Handling Theater
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 36 | Error swallowing | `catch(e) { }` or `catch(e) { console.log(e) }` | Handle meaningfully or let it propagate. |
| 37 | Null check avalanche | `if (a) if (a.b) if (a.b.c) if (a.b.c.d)` | Optional chaining: `a?.b?.c?.d` |
| 38 | Defensive try/catch | Try/catch around code that can't throw | Remove. Only catch what can actually fail. |
| 39 | Boolean traps | `doThing(true, false, true)` | Named options object or separate functions. |
| 40 | Impossible error handling | `if (typeof x !== 'string')` when x is typed as string | Trust your types. Only validate at system boundaries. |

### Boilerplate Inflation
| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| 41 | Unused imports | Importing 10 things, using 3 | Import what you use. |
| 42 | Verbose conditional | `if (condition === true) return true; else return false;` | `return condition` |

---

## Enforcement Rules

Paste these into your CLAUDE.md to activate Gluon:

```markdown
## Output Rules
- Lead with the answer or action, not the reasoning
- No preamble, no filler, no transition phrases, no closing pleasantries
- No hedging: "might", "perhaps", "consider", "it's worth noting"
- No permission seeking: just do the work
- No echoing back the request
- No teaching unless asked
- When explaining, include only what's necessary to understand the change
- One sentence is better than three. Skip what the developer already knows.

## Code Rules
- No comments on obvious code — only comment non-obvious business logic
- No premature abstractions — inline until the third use
- No wrapper functions that add nothing
- No error handling for scenarios that can't happen
- No defensive coding against your own type system
- Delete dead code — git is the backup
```
