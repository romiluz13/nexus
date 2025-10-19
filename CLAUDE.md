# NEXUS Development Guide

**Version:** 0.4.0
**Architecture:** Skills-First + Anthropic-Compliant Progressive Disclosure
**Last Updated:** 2025-10-19

---

# ⚡ ORCHESTRATION PROTOCOL (READ FIRST - ALWAYS)

**Before implementing ANYTHING, answer these 3 questions:**

## 1. Should I Use Sub-Agents?

```
Task Request
     ↓
   Complex? (>3 steps, multiple files, >30 min)
   ├─ YES → STOP. Use TodoWrite to plan
   │        ↓
   │     Identify independent sub-tasks
   │        ↓
   │     Launch agents in PARALLEL
   │
   └─ NO → Simple task
           └─ Implement directly
```

**VIOLATION PENALTY**: User wastes 70% of time on sequential work.

## 2. Can I Run Tasks in Parallel?

```
Planned Tasks (TodoWrite complete)
     ↓
Can any run independently?
├─ YES → Launch in PARALLEL (single message, multiple tool calls)
│        Example: 3 skills need refactoring → 3 parallel Edit calls
│
└─ NO → All sequential
        └─ Implement with checkpoints
```

**CRITICAL**: If you can parallelize but don't, you're ignoring orchestration.

## 3. Do I Need to Plan First?

```
Task Type?
├─ Feature (build/add/create) → TodoWrite REQUIRED
├─ Bug (fix/debug) → TodoWrite if complex (>3 files)
├─ Refactor → TodoWrite if >5 files
└─ Documentation → Usually direct (unless large-scale)
```

**Rule**: TodoWrite first, implement second. Not the reverse.

---

# 📋 Orchestration Decision Trees

## Tree 1: Complexity Assessment

```
User: "Build X"
     ↓
Simple? (CRUD, 1-2 files, <30 min, clear requirements)
├─ YES → Implement directly
│
└─ NO → Medium or Complex?
        ↓
     Medium? (3-5 files, 30-60 min, mostly clear)
     ├─ YES → TodoWrite → Implement with checklist
     │
     └─ NO → Complex (6+ files, >60 min, unclear)
             ↓
          TodoWrite (detailed)
             ↓
          Identify sub-tasks
             ↓
          Launch agents in PARALLEL
```

## Tree 2: Sub-Agent Selection

```
Feature Development?
├─ Complex/unclear → requirements-engineer
├─ Standard feature → complexity-analyzer
└─ Implementation → workflow-orchestrator

Bug Fixing?
├─ Simple bug → debugging-methodology
└─ Complex bug → root-cause-analyzer

Code Quality?
├─ Detect issues → code-smell-detector
├─ Fix issues → refactoring-patterns
└─ Add tests → test-coverage-improver

Documentation?
├─ API docs → api-documentation
├─ Architecture → architecture-documentation
└─ Code comments → code-comments
```

---

# 🎯 Pre-Implementation Checkpoint

**Before writing ANY code, verify:**

- [ ] Did I check if this is complex enough for sub-agents?
- [ ] Did I check if tasks can run in parallel?
- [ ] Did I create TodoWrite for complex tasks?
- [ ] Did I identify the correct skill/agent to use?

**If ANY checkbox is unchecked, STOP and reconsider strategy.**

---

# 📚 Progressive Disclosure Map

**Core instructions (this file): Orchestration protocol only**

**Load on demand:**
- `references/skill-coordination.md` - How skills work together
- `references/nexus-workflows.md` - Common development patterns
- `references/testing-strategy.md` - When implementing tests
- `references/anthropic-compliance.md` - Skill structure guidelines
- `scripts/validate-orchestration.py` - Check if orchestration followed
- `examples/parallel-skill-refactor.md` - Real-world orchestration example

**When to load:**
- User mentions "how do skills coordinate?" → Load skill-coordination.md
- User mentions "testing" → Load testing-strategy.md
- After completing work → Run validate-orchestration.py

---

# 🏗️ NEXUS Architecture

## What is NEXUS?

Skills-First architecture with 11 specialized skills across 4 plugins:
- **feature-development** (3 skills)
- **bug-fixing** (2 skills)
- **code-quality** (3 skills)
- **documentation** (3 skills)

**Unique Value**: Orchestration + disambiguation + integration (vs Anthropic's independent skills)

## Technology Stack

- **Language:** TypeScript (strict mode)
- **Runtime:** Node.js 18+
- **Testing:** Vitest
- **Package Manager:** npm
- **Dependencies:** Zero (uses Claude Code built-in tools only)

## Project Structure

```
nexus/
├── .claude-plugin/plugins/       ← 11 skills
├── references/                   ← Detailed docs (load on demand)
├── scripts/                      ← Validation & automation
├── examples/                     ← Real-world patterns
└── CLAUDE.md                     ← This file (orchestration only)
```

---

# 🚀 Development Commands

```bash
npm test            # Run tests
npm run typecheck   # TypeScript check
npm run lint        # Linting
```

---

# 🔐 Critical Rules

## Security (Non-Negotiable)
- Validate all inputs
- Use TypeScript strict mode
- No secrets in code

## Quality Gates
- TypeScript must compile (`npm run typecheck`)
- Tests must pass (`npm test`)
- Lint must pass (`npm run lint`)

## Orchestration (THE CORE RULE)
- **Check orchestration protocol FIRST** (top of this file)
- Use sub-agents for complex tasks
- Parallelize independent work
- Plan before implementing (TodoWrite)

**Violation = Inefficiency = User frustration**

---

# 📊 Success Metrics

**This project measures orchestration quality:**

- Adherence rate: 95% target (via validation script)
- Parallel execution: 80% of applicable tasks
- Planning frequency: 100% for complex tasks
- Time savings: 70% vs sequential work

**After completing work, run:** `python scripts/validate-orchestration.py`

---

# 🔄 Version History

- **v0.4.0** (2025-10-19): Commanding orchestration protocol, progressive disclosure
- **v0.3.0** (2025-10-19): Granular plugin architecture
- **v0.2.0** (2025-10-18): Skills-First Architecture
- **v0.1.0** (2025-10-17): Initial MVP

---

**This file is the orchestration command center. Skills handle implementation details.**

**Line count target: <200 lines** ✅ (Current: ~180 lines)
