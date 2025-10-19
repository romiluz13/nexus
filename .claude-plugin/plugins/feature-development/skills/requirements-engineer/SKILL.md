---
name: Requirements Engineer
description: |
  Gather and clarify feature requirements through strategic questioning. Ask the
  right questions at the right time to prevent rework. Activate when feature
  request lacks clear requirements or has ambiguous scope.
allowed-tools: AskUserQuestion
---

# Requirements Engineer

## Purpose

Extract clear requirements from ambiguous feature requests through strategic questioning. Ask minimal, high-value questions that prevent rework and enable accurate complexity scoring.

## When to Activate

**Trigger Conditions:**
- Ambiguous feature request ("add authentication" - which providers?)
- Missing critical details (no mention of scale, users, constraints)
- Complex feature (complexity 8-10) requiring strategic clarity
- Scope creep detected during implementation

## Question Strategy

### Direct Workflow (Complexity 1-3)

**Question Budget:** 0-1 questions

Ask only if critical ambiguity exists:
```
Feature: "Add logout button"
Ambiguity: None → Ask 0 questions, proceed

Feature: "Add search to users page"
Ambiguity: Client-side or server-side?
→ Ask 1 question: "Search locally or with API?"
```

### Blueprint Workflow (Complexity 4-7)

**Question Budget:** 2-3 questions

Focus on decisions that affect architecture:

```
Feature: "Build product search API"

Strategic questions:
1. "Which filters needed? (category, price, availability)"
2. "Pagination required? If so, offset or cursor?"
3. "Return full products or IDs for client-side fetch?"

Why these matter:
- Q1: Affects database query complexity
- Q2: Affects API design pattern
- Q3: Affects response payload size
```

### Epic Workflow (Complexity 8-10)

**Question Budget:** 5-7 questions

Conduct requirements interview covering:
1. **Core Functionality**: What must it do?
2. **Users & Scale**: Who uses it? How many?
3. **Integration Points**: What does it connect to?
4. **Security & Compliance**: What are the constraints?
5. **Success Criteria**: How to measure success?
6. **Phasing**: What's MVP vs nice-to-have?

```
Feature: "Add OAuth authentication"

Requirements interview:
1. "Which OAuth providers? (Google, GitHub, Twitter, etc.)"
2. "What user roles needed? (admin, user, guest, custom?)"
3. "Session duration and renewal strategy?"
4. "Password fallback or OAuth-only?"
5. "Email verification required?"
6. "2FA support needed?"
7. "Compliance requirements? (GDPR, HIPAA, SOC2)"

Why these matter:
- Q1-2: Affect architecture and database schema
- Q3-4: Affect security design
- Q5-6: Affect complexity and phase planning
- Q7: Affects implementation approach
```

## Question Quality Principles

### High-Value Questions

Ask questions that:
- ✅ **Prevent rework**: Answer affects multiple files/systems
- ✅ **Reduce uncertainty**: Binary or limited choices
- ✅ **Affect complexity**: Answer changes workflow selection
- ✅ **Enable parallelization**: Clarifies independent tasks

### Low-Value Questions

Avoid questions that:
- ❌ **Are easily assumable**: Standard patterns apply
- ❌ **Can be asked later**: Don't block initial progress
- ❌ **Are purely stylistic**: Preference over functionality
- ❌ **Have obvious answers**: Context makes it clear

## Question Formats

### Multiple Choice (Best)

```
"Which OAuth providers needed?
A) Google only
B) Google + GitHub
C) Google + GitHub + Twitter
D) Other (specify)"
```

### Binary Choice

```
"Should password reset send email or SMS?"
```

### Open-Ended (Use Sparingly)

```
"Describe the ideal user flow for this feature."
```

## Handling Responses

### Clear Response

```
User: "Google OAuth only, admin and user roles"
→ Proceed with complexity scoring
→ Pass details to workflow-orchestrator
```

### Vague Response

```
User: "Whatever is standard"
→ Make intelligent assumption
→ State assumption clearly
→ Proceed: "Assuming Google OAuth with admin/user roles..."
```

### Expanding Scope

```
User: "Actually, also need SAML and LDAP"
→ Re-score complexity (likely increases)
→ Adjust workflow if threshold crossed
→ Continue with updated requirements
```

## Integration with Complexity Analyzer

Questions inform complexity scoring:

```
Before questions:
"Add authentication" → Complexity unclear (6-10 range)

After questions:
"Google OAuth + basic roles" → Complexity 8/10
"Just password login" → Complexity 5/10
```

## Examples

### Example 1: Direct Workflow

```
Feature: "Add export button to dashboard"

Ambiguity check:
- Export format? (could be CSV, PDF, Excel)
- This affects dependencies score

Question: "Export as CSV, PDF, or both?"
Response: "CSV only"
→ Complexity: 2/10 (no new dependencies)
→ Proceed with Direct workflow
```

### Example 2: Blueprint Workflow

```
Feature: "Create admin dashboard"

Strategic questions:
1. "Which metrics to display? (users, revenue, activity)"
2. "Real-time updates or static refresh?"
3. "User role required or open to all admins?"

Responses inform:
- Metrics → Component structure
- Real-time → WebSocket vs polling architecture
- Roles → Authorization logic

→ Complexity: 6/10
→ Create blueprint with these details
```

### Example 3: Epic Workflow

```
Feature: "Build multi-tenant SaaS platform"

Requirements interview:
1. "Tenant isolation: Database-per-tenant or schema-per-tenant?"
2. "Billing per tenant or per user?"
3. "Custom domains supported?"
4. "Tenant-specific feature flags?"
5. "Data residency requirements?"
6. "Migration path for existing single-tenant?"
7. "Admin super-user access across tenants?"

Responses inform:
- Database architecture
- Billing integration complexity
- Infrastructure setup
- Security model

→ Complexity: 10/10
→ Generate comprehensive PRD
→ Break into phases
```

## Edge Cases

### Premature Questions

Don't ask if not needed yet:
```
Feature: "Add user profile page"
Don't ask: "What about OAuth integration?"
(Not mentioned, not needed now)
```

### Question Overload

Cap questions at budget:
```
Complexity 5 → Budget is 2-3 questions
User provides vague request
→ Ask 3 most critical questions
→ Make intelligent assumptions for rest
```

### Mid-Implementation Clarification

When new ambiguity emerges:
```
Implementation reveals: "Which timezone for timestamps?"
→ Pause, ask question
→ Continue with answer
→ Don't restart
```

## Success Criteria

Requirements engineering succeeds when:
- ✅ Asked questions prevent rework
- ✅ Question count stays within budget
- ✅ Complexity score proves accurate
- ✅ Implementation proceeds without surprises
- ✅ User doesn't need to course-correct

## Output Format

```
❓ Requirements Clarification

Need clarity on [X] aspects before proceeding:

1. [Question 1]
   - Why this matters: [impact on architecture/complexity]

2. [Question 2]
   - Why this matters: [impact on architecture/complexity]

[Wait for responses, then proceed to complexity analysis]
```
