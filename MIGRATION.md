# Migration Guide: From Traditional Plugins to NEXUS

This guide helps you transition from traditional Claude Code plugins (dotai, jitd, ccpm, etc.) to NEXUS's state-of-the-art Skills-First Architecture.

## 🎯 Why Migrate?

**Traditional Plugin Problems:**
- 📚 50,000+ tokens always loaded (slow, expensive)
- 🧠 15+ commands to memorize (cognitive overhead)
- 🔧 Manual orchestration through CLAUDE.md rules
- 📉 All-or-nothing context loading

**NEXUS Benefits:**
- ⚡ 8,500 tokens (85% reduction)
- 🗣️ Zero commands (just natural language)
- 🤖 Automatic orchestration through Skills
- 🎯 Progressive disclosure (only load what's needed)

## 📊 Feature Comparison

| Feature | dotai | jitd | NEXUS |
|---------|-------|------|-------|
| Token Load | 50k+ | 12k | **8.5k** |
| Commands to Learn | 15+ | 10+ | **0** |
| Context Loading | All | All | **Progressive** |
| Orchestration | Manual | Manual | **Automatic** |
| Workflows | Fixed (3) | Fixed (2) | **Adaptive** |
| Plugin Structure | Monolithic | Monolithic | **Granular** |

## 🚀 Migration Path

### Step 1: Understand the Paradigm Shift

**OLD (Command-Based):**
```
User types: /dotai:create-prd authentication
→ Claude follows CLAUDE.md orchestration rules
→ User must know correct command
```

**NEW (Skills-First):**
```
User says: "Add authentication"
→ Skills auto-activate based on keywords
→ No commands, just natural language
```

### Step 2: Map Your Workflow

**From dotai:**

| dotai Command | NEXUS Equivalent | How to Trigger |
|---------------|------------------|----------------|
| `/dotai:create-prd` | requirements-engineer + complexity-analyzer + workflow-orchestrator | Say: "Add [feature]" |
| `/dotai:parse-prd` | workflow-orchestrator | Automatic after PRD generation |
| `/dotai:update-app-design` | architecture-documentation | Say: "Document the architecture" |
| `/dotai:update-tech-stack` | architecture-documentation | Say: "Update tech documentation" |

**From jitd:**

| jitd Command | NEXUS Equivalent | How to Trigger |
|--------------|------------------|----------------|
| `/jitd:implement` | workflow-orchestrator | Say: "Implement [feature]" |
| `/jitd:fix` | debugging-methodology + root-cause-analyzer | Say: "Fix [bug]" |
| `/jitd:test` | test-coverage-improver | Say: "Add tests for [code]" |

### Step 3: Install NEXUS

```bash
# Remove old plugin (optional but recommended)
/plugin uninstall dotai  # or jitd, etc.

# Add NEXUS marketplace
/plugin marketplace add /path/to/nexus

# Install NEXUS
/plugin install nexus@nexus
```

### Step 4: Adapt Your Workflow

**Before (dotai):**
```
1. /dotai:create-prd feature-name
2. Review PRD
3. /dotai:parse-prd feature-name
4. Manually track progress
5. /dotai:update-app-design
```

**After (NEXUS):**
```
1. "Add [feature with description]"
   → requirements-engineer asks clarifying questions
   → complexity-analyzer scores it
   → workflow-orchestrator selects workflow
   → Executes with automatic TodoWrite tracking
   → Completes with quality gates
   
2. Done! No manual orchestration needed.
```

## 🎓 Learning Curve

### Phase 1: Basics (Day 1)
**Learn:** Just describe what you need in natural language

**Examples:**
- ❌ Don't: `/dotai:create-prd auth-system`
- ✅ Do: "Add user authentication with OAuth"

### Phase 2: Nuance (Week 1)
**Learn:** Trust the skills to orchestrate automatically

**Examples:**
- "Fix the login bug" → debugging-methodology activates
- "Refactor this messy code" → code-smell-detector + refactoring-patterns
- "Document the API" → api-documentation activates

### Phase 3: Advanced (Week 2+)
**Learn:** Skills work together sequentially

**Example:**
```
"Add payment processing and test it"

→ requirements-engineer (clarifies: Stripe? currencies?)
→ complexity-analyzer (scores: 9/10)
→ workflow-orchestrator (Epic workflow, phased)
→ code-smell-detector (reviews quality)
→ test-coverage-improver (adds tests)
```

## 📝 Common Migration Scenarios

### Scenario 1: Feature Development

**dotai approach:**
```
/dotai:create-prd-interactive feature-name
[Answer 9-10 questions]
/dotai:parse-prd feature-name
[Manually implement from checklist]
```

**NEXUS approach:**
```
"Add [feature]"
→ requirements-engineer asks strategic questions
→ Automatically scores complexity
→ Selects optimal workflow
→ Executes implementation
→ Tracks progress with TodoWrite
```

**Time savings:** 40% (less manual orchestration)

### Scenario 2: Bug Fixing

**Traditional approach:**
```
1. Manually diagnose issue
2. Search for solutions
3. Implement fix
4. Test manually
5. Hope it doesn't break again
```

**NEXUS approach:**
```
"Fix [describe bug]"
→ debugging-methodology executes 5-phase process:
   1. Reproduce & Understand
   2. Diagnose Root Cause (with root-cause-analyzer)
   3. Fix Implementation
   4. Verify Fix
   5. Prevent Recurrence (adds tests, guards)
```

**Quality improvement:** Prevention mechanisms built-in

### Scenario 3: Code Quality

**jitd approach:**
```
/jitd:review [file]
[Manually apply suggestions]
```

**NEXUS approach:**
```
"Refactor this code" or "Improve code quality"
→ code-smell-detector identifies issues
→ refactoring-patterns applies fixes incrementally
→ Verifies after each change
→ test-coverage-improver ensures coverage
```

**Safety improvement:** Automated verification

## ⚠️ Common Pitfalls

### Pitfall 1: Trying to Use Commands
**Issue:** Muscle memory from old plugins

**Example:**
```
❌ "/nexus create-prd auth"
✅ "Add authentication system"
```

**Solution:** Trust natural language, forget commands

### Pitfall 2: Over-Specifying
**Issue:** Trying to control the workflow too much

**Example:**
```
❌ "Use Epic workflow to add a logout button"
   (logout button is simple, should be Direct workflow)

✅ "Add logout button"
   (complexity-analyzer correctly scores it low, Direct workflow activates)
```

**Solution:** Describe WHAT you need, let skills determine HOW

### Pitfall 3: Missing Context
**Issue:** Too vague for skills to activate correctly

**Example:**
```
❌ "Fix it"
   (Fix what? Skills can't determine intent)

✅ "Fix the login authentication error on line 45"
   (Clear enough for debugging-methodology to activate)
```

**Solution:** Provide enough context for skill activation

## 🔍 Troubleshooting

### "Skills aren't activating"
**Cause:** Unclear or ambiguous request

**Solution:**
- Be specific: "Add feature" not "Help me"
- Include keywords: "fix", "refactor", "document", etc.
- Provide context: What are you trying to do?

### "Wrong skill activated"
**Cause:** Trigger keyword matched wrong skill

**Example:** "Make this faster"
- Could be: refactoring-patterns (code optimization)
- Could be: workflow-orchestrator (architectural change)

**Solution:** Be more specific:
- "Optimize this code" → refactoring-patterns
- "Redesign for better performance" → workflow-orchestrator

### "Skills feel slower than commands"
**Cause:** Skills ask clarifying questions

**Why this is good:**
- Prevents rework
- Ensures correct understanding
- Better final result

**If you want speed:**
- Provide more detail upfront
- Example: "Add Google OAuth authentication with admin/user roles and 24-hour sessions"
- requirements-engineer will ask fewer questions

## 📊 Success Metrics

Track these to measure successful migration:

**Week 1:**
- [ ] Using natural language instead of commands
- [ ] Skills activating correctly 70%+ of time

**Week 2:**
- [ ] Skills activating correctly 90%+ of time
- [ ] No longer thinking about commands
- [ ] Trusting automatic orchestration

**Week 4:**
- [ ] Faster development than before
- [ ] Better code quality (prevention mechanisms)
- [ ] More comprehensive documentation

## 💡 Pro Tips

### Tip 1: Start Simple
Begin with simple requests to build confidence:
- "Add logout button" (simple)
- "Fix this error" (clear)
- "Document this function" (specific)

### Tip 2: Leverage Sequential Work
Skills work together naturally:
- "Add feature and test it"
- "Fix bug and document the solution"
- "Refactor code and update tests"

### Tip 3: Provide Rich Context
The more context, the better:
```
Good: "Add authentication"

Better: "Add user authentication with OAuth2"

Best: "Add user authentication with Google OAuth, support admin and user roles, 
       and implement JWT tokens with 24-hour expiration"
```

### Tip 4: Trust the Process
- Let complexity-analyzer determine complexity
- Let workflow-orchestrator choose the workflow
- Let skills orchestrate automatically
- Review and approve when asked

## 🚀 Next Steps

1. **Install NEXUS** following Step 3 above
2. **Try simple tasks** to build confidence
3. **Read skill descriptions** in `.claude-plugin/plugins/*/skills/*/SKILL.md`
4. **Practice natural language** requests
5. **Trust the orchestration** - it works!

## 🤝 Need Help?

- **Issues:** [GitHub Issues](https://github.com/your-org/nexus/issues)
- **Questions:** [GitHub Discussions](https://github.com/your-org/nexus/discussions)
- **Examples:** See EXAMPLES.md (coming soon)

## 📚 Further Reading

- **CLAUDE.md:** Development guide
- **README.md:** Full documentation
- **SYNTHESIS.md:** Architecture patterns
- **CONTRIBUTING.md:** How to extend NEXUS

---

**Welcome to the future of Claude Code plugins!** ✨
