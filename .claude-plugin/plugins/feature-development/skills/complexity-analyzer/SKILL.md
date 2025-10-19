---
name: complexity-analyzer
description: |
  Analyze feature complexity using 5-dimension scoring (0-10 scale). Evaluate technical
  scope, architecture impact, dependencies, testing needs, and security. Activate when
  user requests to build, add, create, or implement features.
allowed-tools: Read, Grep, Glob
---

# Complexity Analyzer

## Purpose

Analyze feature requests to determine implementation complexity using a standardized 5-dimension scoring system. Provides objective complexity score (0-10) that guides workflow selection.

## When to Activate

**Trigger Keywords:**
- "build", "add", "create", "implement", "develop"
- Combined with: "feature", "API", "component", "system", "integration"

**Disambiguation:**
- "Make this faster" → If adding new functionality, activate. If optimizing existing code, defer to refactoring-patterns
- "Improve X" → If X is a feature name, activate. If X is code quality, defer to code-smell-detector
- "Fix X" → Defer to debugging-methodology unless "fix" means "add missing feature"

## How to Use

### Decision Tree

```
User: "Build/Add X"
     ↓
Analyze request
     ↓
Score 5 dimensions (0-2 each)
├─ Technical Scope
├─ Architecture Impact
├─ Dependencies
├─ Testing Complexity
└─ Security & Compliance
     ↓
Calculate total (0-10)
     ↓
  Total Score?
  ├─ 0-3: Simple → Recommend Direct Workflow
  ├─ 4-7: Moderate → Recommend Blueprint Workflow
  └─ 8-10: Complex → Recommend Epic Workflow
```

### Quick Scoring Guide

**Technical Scope**: How many layers? (0=1 file, 1=1 layer, 2=multi-layer)
**Architecture**: New patterns? (0=none, 1=minor, 2=major)
**Dependencies**: New libraries? (0=none, 1=few, 2=many)
**Testing**: Test types? (0=unit, 1=integration, 2=E2E/security)
**Security**: Criticality? (0=none, 1=basic, 2=critical)

**For detailed scoring criteria** → Load `references/scoring-guide.md`

## Output Format

```
🔍 Complexity Analysis: [Feature Name]

📊 Score Breakdown:
   - Technical Scope: [X]/2 - [Brief reason]
   - Architecture: [X]/2 - [Brief reason]
   - Dependencies: [X]/2 - [Brief reason]
   - Testing: [X]/2 - [Brief reason]
   - Security: [X]/2 - [Brief reason]

📈 Total Complexity: [X]/10

🎯 Recommendation: [Direct/Blueprint/Epic] Workflow
⏱️ Estimated Time: [X minutes/hours]
```

## Process

1. **Read request carefully** - Extract feature name and requirements
2. **Score each dimension** (0-2 points each)
   - If uncertain, load `references/scoring-guide.md` for detailed criteria
3. **Calculate total** - Sum all dimension scores
4. **Interpret score**:
   - 0-3 = Simple (Direct, 5-20 min)
   - 4-7 = Moderate (Blueprint, 20-60 min)
   - 8-10 = Complex (Epic, 1-3 hours, phased)
5. **Output analysis** using format above
6. **Pass to workflow-orchestrator** for execution

## Examples

**Quick examples** (for detailed examples, see `examples/complexity-examples.md`):

**Simple** (Score: 1/10):
- "Add logout button" - Single file, existing pattern, no dependencies

**Moderate** (Score: 5/10):
- "Build product search API" - Backend + DB, new endpoint, testing

**Complex** (Score: 10/10):
- "Add OAuth authentication" - Multi-layer, new arch, critical security

## Edge Cases

**Unclear requirements** → Ask 1-2 clarifying questions before scoring

**Scope creep mid-implementation** → Re-score and switch workflow if needed

**When uncertain** → Round up for security/production, round down for CRUD

**For detailed edge cases** → Load `references/edge-cases.md`

## Integration

Pass complexity score to workflow-orchestrator skill for automatic workflow selection and execution.

## Success Criteria

- ✅ Actual implementation time matches estimate (±20%)
- ✅ Workflow selection proves appropriate
- ✅ No major surprises during implementation
- ✅ Quality gates pass without rework
