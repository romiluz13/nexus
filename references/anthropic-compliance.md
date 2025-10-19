# Anthropic Skills Compliance Guide

**Load this when**: Creating or modifying skills

---

## Official Spec Requirements

Per Anthropic's agent_skills_spec.md:

### Required YAML Frontmatter
```yaml
---
name: skill-name  # lowercase, hyphens only
description: What the skill does and when Claude should use it
---
```

### Optional Frontmatter
```yaml
license: MIT  # Or LICENSE.txt
allowed-tools: [Read, Write, Edit]  # Claude Code only
metadata:
  category: development  # Custom properties
```

---

## SKILL.md Size Guidelines

| Type | Anthropic Standard | NEXUS Target |
|------|-------------------|--------------|
| Minimal | 33-100 lines | 100-150 lines |
| Standard | 100-200 lines | 150-200 lines |
| Complex | 200-300 lines | Max 250 lines |

**Rationale**: NEXUS adds orchestration (disambiguation, integration) → slightly longer OK

---

## Progressive Disclosure Structure

```
skill-name/
├── SKILL.md (150-200 lines - core procedures)
├── references/
│   ├── detailed-workflow.md (load on demand)
│   ├── api-specs.md (technical details)
│   └── edge-cases.md (uncommon scenarios)
├── scripts/
│   └── automation.py (executable code)
├── examples/
│   └── real-world-case.md (sample usage)
└── assets/
    └── template.txt (output template)
```

---

## Writing Style: Imperative Voice

**Good (Anthropic standard)**:
- "To analyze complexity, score the task"
- "Run the validation script"
- "Load the reference file when needed"

**Bad (avoid)**:
- "You should analyze complexity"
- "Claude should run validation"
- "It's important to load references"

---

## Description Quality

**Template**:
```
[What skill does] + [When Claude should use it]
```

**Good Example**:
```
description: Detect code quality issues and code smells. Identify long functions,
  deep nesting, duplication, magic numbers. Use when user requests code quality
  analysis or before refactoring.
```

**Bad Example**:
```
description: Helps with code quality
```

---

## Decision Trees > Text

**Anthropic uses visual decision trees**:

```
User Request
     ↓
  Complex?
  ├─ YES → Plan first
  └─ NO  → Implement directly
```

**Not this**:
"If the request is complex, you should plan first. Otherwise, implement directly."

---

## Resource Organization

### scripts/ (Token-Free Execution)
- Executable code Claude can run WITHOUT loading
- Python, Bash, JavaScript
- Use for: Repeated operations, deterministic logic

### references/ (Load on Demand)
- Detailed documentation
- API specs, schemas, workflows
- Load only when Claude needs context

### examples/ (Learning Material)
- Real-world usage patterns
- Before/after comparisons
- Load when user needs examples

### assets/ (Output Resources)
- Templates, images, fonts
- NOT loaded to context
- Used IN the output Claude generates

---

## NEXUS Exceptions (Why We Differ)

### We Keep (Non-Standard)
1. **Integration sections** - How skills coordinate (unique value)
2. **Disambiguation patterns** - Prevent conflicts (unique value)
3. **Success Criteria** - Quality gates (useful for verification)

### We Add (Anthropic-Compliant)
1. **Progressive disclosure** - scripts/, references/, examples/
2. **Decision trees** - Visual workflows
3. **Imperative voice** - "Do X" not "You should"

### We Remove
1. **Verbose examples** - Move to examples/ folder
2. **Detailed patterns** - Move to references/ folder
3. **Edge cases** - Move to references/edge-cases.md

---

**Target**: Anthropic compliance + NEXUS orchestration value
**Result**: Best of both worlds
