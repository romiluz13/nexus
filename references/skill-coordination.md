# NEXUS Skill Coordination

**Load this when**: User asks "how do skills work together?"

---

## Skill Priority System

NEXUS uses priority levels to prevent conflicts:

### Primary Action (Activate First)
- `requirements-engineer` - Clarifies unclear requirements
- `complexity-analyzer` - Scores feature complexity
- `workflow-orchestrator` - Executes implementation
- `debugging-methodology` - Fixes bugs
- `root-cause-analyzer` - Advanced diagnostics

### Quality (Activate During/After)
- `code-smell-detector` - Detects quality issues
- `refactoring-patterns` - Applies fixes
- `test-coverage-improver` - Adds tests

### Documentation (Activate After)
- `api-documentation` - API docs
- `architecture-documentation` - Architecture docs
- `code-comments` - Inline comments

---

## Sequential Flow

```
User: "Build auth and document it"
     ↓
1. requirements-engineer (if unclear)
   ↓
2. complexity-analyzer (score: 9/10)
   ↓
3. workflow-orchestrator (implement)
   ↓
4. code-smell-detector (review quality)
   ↓
5. refactoring-patterns (fix issues if found)
   ↓
6. api-documentation (create docs)
```

---

## Disambiguation Rules

**"fix" triggers**:
- Bug/error → `debugging-methodology`
- Missing feature → `complexity-analyzer`
- Code quality → `refactoring-patterns`

**"improve" triggers**:
- Feature enhancement → `complexity-analyzer`
- Code quality → `code-smell-detector`
- Test coverage → `test-coverage-improver`

**"add" triggers**:
- New feature → `complexity-analyzer`
- Tests → `test-coverage-improver`
- Documentation → Specific doc skill

---

## Integration Points

Skills communicate through shared context:

1. **Requirements** → Implementation
   - requirements-engineer outputs requirements
   - workflow-orchestrator reads requirements

2. **Quality Detection** → Fixing
   - code-smell-detector outputs issues
   - refactoring-patterns reads issues and fixes

3. **Implementation** → Documentation
   - workflow-orchestrator implements feature
   - Documentation skills read implementation

---

**Total Skills**: 11 (all specialized, no overlap)
**Conflict Rate**: 0% (via disambiguation)
