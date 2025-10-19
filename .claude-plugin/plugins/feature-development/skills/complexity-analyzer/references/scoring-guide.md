# Complexity Analyzer - Detailed Scoring Guide

**Load this when**: Need detailed criteria for each dimension

---

## 1. Technical Scope (0-2 points)

Score the breadth of implementation:

### 0 points - Minimal
- Single file/function change
- No new components
- Existing patterns only
- **Example**: "Add button to header"

### 1 point - Moderate
- Multiple files, single layer (frontend OR backend OR database)
- 2-5 files changed
- One technology stack
- **Example**: "Create user profile page"

### 2 points - Extensive
- Multiple layers (frontend + backend + database)
- 6+ files changed
- Multiple technology stacks
- **Example**: "Build authentication system"

---

## 2. Architecture Impact (0-2 points)

Evaluate architectural changes required:

### 0 points - None
- Uses 100% existing patterns
- Fits into current architecture perfectly
- No new concepts introduced
- **Example**: "Add another CRUD endpoint like existing ones"

### 1 point - Minor
- Introduces one new pattern type
- Small architectural extension
- Doesn't change core design
- **Example**: "Add caching layer to existing API"

### 2 points - Major
- New architectural component
- Changes system design
- Introduces new paradigm
- **Example**: "Add real-time WebSocket service"

---

## 3. Dependencies (0-2 points)

Assess external dependencies needed:

### 0 points - None
- No new dependencies
- Uses existing libraries only
- Zero npm/pip installs
- **Example**: "Rearrange existing UI components"

### 1 point - Few
- 1-2 well-known, stable libraries
- Minimal configuration required
- Low maintenance burden
- **Example**: "Add date-fns for date formatting"

### 2 points - Many
- 3+ dependencies
- Custom integrations required
- Multiple external services
- **Example**: "Integrate Stripe, SendGrid, and Twilio"

---

## 4. Testing Complexity (0-2 points)

Determine testing requirements:

### 0 points - Simple
- Unit tests only
- Pure functions, no side effects
- Easy to test in isolation
- **Example**: "Pure utility function"

### 1 point - Moderate
- Unit + integration tests
- Database interactions
- API contracts
- **Example**: "API endpoint with database"

### 2 points - Complex
- E2E testing required
- Security testing needed
- Performance testing critical
- Multiple test environments
- **Example**: "Payment processing flow"

---

## 5. Security & Compliance (0-2 points)

Evaluate security criticality:

### 0 points - None
- No security concerns
- No sensitive data
- Public, read-only functionality
- **Example**: "Change button color"

### 1 point - Basic
- Input validation required
- Sanitization needed
- Basic auth check
- **Example**: "Contact form with email"

### 2 points - Critical
- Authentication/authorization
- Payment processing
- PII (Personally Identifiable Information)
- Compliance requirements (GDPR, HIPAA, SOC2)
- **Example**: "OAuth authentication with RBAC"

---

## Scoring Decision Matrix

| Dimension | 0 Points | 1 Point | 2 Points |
|-----------|----------|---------|----------|
| **Scope** | 1 file | 1 layer, 2-5 files | Multi-layer, 6+ files |
| **Architecture** | Existing patterns | 1 new pattern | New component |
| **Dependencies** | None | 1-2 libraries | 3+ or custom |
| **Testing** | Unit only | Unit + integration | E2E + security |
| **Security** | None | Basic validation | Critical auth/payment |

---

## Total Score Interpretation

### 0-3 Points: Simple
- **Workflow**: Direct
- **Time**: 5-20 minutes
- **Approach**: Implement directly, no planning needed
- **Examples**: UI tweaks, simple buttons, text changes

### 4-7 Points: Moderate
- **Workflow**: Blueprint
- **Time**: 20-60 minutes
- **Approach**: Light planning, checkpoints during implementation
- **Examples**: CRUD endpoints, search features, dashboards

### 8-10 Points: Complex
- **Workflow**: Epic
- **Time**: 1-3 hours, phased implementation
- **Approach**: Full PRD, detailed planning, multiple checkpoints
- **Examples**: Authentication, payment systems, real-time features

---

## When to Adjust Scores

### Round UP (+1) when:
- Security is involved (even minor)
- Multiple teams affected
- Production system (not dev/staging)
- User-facing feature (not internal tool)
- External integrations
- Compliance requirements

### Round DOWN (-1) when:
- Existing patterns cover 90%+
- Simple CRUD operation
- No external integrations
- Internal tool only
- Dev/staging environment only

---

**Remember**: Scoring is a guide, not a law. Use judgment and adjust based on project context.
