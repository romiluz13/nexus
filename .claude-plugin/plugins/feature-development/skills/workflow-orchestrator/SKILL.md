---
name: Workflow Orchestrator
description: |
  Orchestrate adaptive workflows based on complexity score. Select and execute
  Direct (1-3), Blueprint (4-7), or Epic (8-10) workflows. Manage implementation
  phases, TodoWrite tracking, and parallel execution.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
---

# Workflow Orchestrator

## Purpose

Execute features using adaptive workflows matched to complexity. Orchestrate Direct, Blueprint, or Epic approaches with intelligent task management and parallel execution.

## When to Activate

Receive complexity score from complexity-analyzer skill, then automatically select and execute appropriate workflow.

## Workflow Types

### Direct Workflow (Complexity 1-3)

**Philosophy:** "Just do it" - implementation ready

**Process:**
1. Quick confirmation (0-1 question max)
2. Implement immediately
3. Run tests
4. Document changes

**Time:** 5-15 minutes
**No TodoWrite** (too simple)

**Example:**
```
Feature: "Add logout button"
Complexity: 1/10

→ Read Header.tsx
→ Add logout button + handler
→ Run tests
→ Done in 8 minutes
```

### Blueprint Workflow (Complexity 4-7)

**Philosophy:** "Plan first, execute with confidence"

**Process:**
1. Ask 2-3 clarifying questions
2. Create implementation blueprint
3. Get user approval
4. Execute with TodoWrite tracking
5. Test and document

**Time:** 15-45 minutes
**Use TodoWrite** for tracking

**Blueprint Structure:**
```
Files to Create/Modify:
├── [file1] - [purpose]
├── [file2] - [purpose]
└── [file3] - [purpose]

Key Functions:
- [functionName(params): ReturnType] - [what it does]

Data Flow:
[ASCII diagram showing flow]

Test Strategy:
- Unit: [what to test]
- Integration: [what to test]
```

**Example:**
```
Feature: "Build product search API"
Complexity: 5/10

→ Ask: "Which filters? Pagination needed?"
→ Create blueprint with file structure
→ Get approval
→ TodoWrite: 5 tasks
→ Execute in parallel where possible
→ Done in 30 minutes
```

### Epic Workflow (Complexity 8-10)

**Philosophy:** "Full PRD → Phased MVP → Iterate"

**Process:**
1. Requirements interview (5-7 questions)
2. Generate comprehensive PRD
3. Break into phases
4. Execute Phase 1 (MVP)
5. User checkpoint
6. Continue with remaining phases

**Time:** 1-3 hours
**Use TodoWrite** per phase

**PRD Structure:**
```markdown
# [Feature Name]

## Problem Statement
[What problem does this solve?]

## User Stories
- As [role], I can [action] so that [benefit]

## Technical Architecture
[ASCII diagram or description]

## Implementation Phases

### Phase 1: MVP (Core Functionality)
[Essential features only]

### Phase 2: Enhancement (Nice-to-Have)
[Additional capabilities]

### Phase 3: Polish (UX/Performance)
[Refinements and optimization]

## Security Considerations
[Authentication, validation, compliance]

## Success Metrics
[How to measure success]
```

**Example:**
```
Feature: "Add OAuth authentication"
Complexity: 10/10

→ Interview: 7 questions about providers, roles, sessions
→ Generate PRD with architecture
→ Phase 1: Google OAuth + basic JWT
→ Execute Phase 1 with TodoWrite
→ Checkpoint: "Phase 1 working, test it"
→ Phase 2: Add roles + protected routes
→ Done in 2 hours across all phases
```

## Execution Strategies

### Parallel Execution

Identify independent tasks and execute simultaneously:

```
Blueprint shows:
1. Create user model (database)
2. Create auth middleware (backend)
3. Build login form (frontend)

Parallel execution:
[User model + auth middleware] → Then login form
```

### Sequential Execution

When dependencies exist, execute in order:

```
Epic Phase 1:
1. Database schema → 2. Backend API → 3. Frontend
(Each depends on previous)
```

### Adaptive Re-scoring

If requirements change mid-implementation:

```
Started: "Add contact form" (Complexity 2, Direct)
Changed: "Also integrate Salesforce + Slack"
→ Re-score: Complexity 6
→ Switch to Blueprint workflow
→ Create blueprint from current progress
→ Continue with TodoWrite
```

## TodoWrite Integration

### When to Use TodoWrite

- ✅ Blueprint workflow (always)
- ✅ Epic workflow (per phase)
- ❌ Direct workflow (too simple)

### Todo Format

```
[TodoWrite for Blueprint/Epic:]

✅ Completed task
🔄 In progress task
⏳ Pending task

Each task includes:
- Clear deliverable
- Acceptance criteria
- Dependencies (if any)
```

## Quality Gates

Before marking feature complete:

- ✅ **Functionality**: Feature works as specified
- ✅ **Tests**: Appropriate tests pass (unit/integration/E2E)
- ✅ **Security**: Input validation, error handling
- ✅ **Documentation**: Code comments, README updates
- ✅ **Performance**: No obvious bottlenecks
- ✅ **Style**: Follows project conventions

## Output Format

### At Start

```
🎯 Executing [Direct/Blueprint/Epic] Workflow
⏱️ Estimated Time: [X minutes/hours]

[Workflow-specific details]
```

### During Execution

```
[For Blueprint/Epic only:]
✅ Completed: [task name]
🔄 In Progress: [task name]
⏳ Pending: [X] remaining tasks
```

### At Completion

```
✨ Feature Complete: [feature name]

📋 Summary:
   - Workflow used: [Direct/Blueprint/Epic]
   - Files changed: [X]
   - Tests added: [X]
   - Time taken: [X] minutes

✅ Quality gates: All passed

📝 Next steps: [Any follow-up recommendations]
```

## Edge Cases

**Blocked by Dependencies:**
- External API unavailable → Document integration contract, use mocks
- Library not installed → Add to package.json, document usage
- Design not ready → Create placeholder, document expectations

**User Feedback Mid-Phase:**
- Adjust current phase plan
- Don't restart from scratch
- Update TodoWrite list
- Continue with modified approach

**Workflow Switching:**
- Direct → Blueprint: Create blueprint from current state
- Blueprint → Epic: Expand into full PRD
- Epic → Blueprint: Simplify if scope reduced

## Success Criteria

Workflow orchestration succeeds when:
- ✅ Selected workflow matches actual complexity
- ✅ Implementation time within estimate
- ✅ Quality gates pass on first attempt
- ✅ User rarely needs to course-correct
- ✅ Parallel execution used effectively

## Integration

Receive complexity score from complexity-analyzer.
Coordinate with requirements-engineer for clarifying questions.
Execute implementation with quality-first approach.
