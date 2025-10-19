# Complexity Analyzer - Real-World Examples

**Load this when**: Need to see how scoring works in practice

---

## Example 1: "Add logout button"

### Analysis

```
Technical Scope: 0/2
Reason: Single file change (Header.tsx or Navbar.tsx)
Detail: Just add button component, call existing logout function

Architecture: 0/2
Reason: Uses 100% existing auth pattern
Detail: Logout function already exists, just triggering it

Dependencies: 0/2
Reason: No new libraries needed
Detail: Uses existing auth library's logout method

Testing: 0/2
Reason: Simple unit test
Detail: Test button renders, test onClick calls logout

Security: 1/2
Reason: Must clear auth state properly
Detail: Need to ensure session/tokens cleared correctly
```

**Total: 1/10 → Direct Workflow**
**Estimated Time**: 5-10 minutes

### Implementation

```tsx
// src/components/Header.tsx
import { useAuth } from '../hooks/useAuth';

export function Header() {
  const { logout } = useAuth();

  return (
    <button onClick={logout}>
      Logout
    </button>
  );
}
```

**Actual Time**: 7 minutes ✅ (matches estimate)

---

## Example 2: "Build product search API"

### Analysis

```
Technical Scope: 1/2
Reason: Backend + database, multiple files
Detail: API route, service layer, database query

Architecture: 1/2
Reason: New search endpoint pattern
Detail: Adding full-text search (new pattern for this app)

Dependencies: 0/2
Reason: Use existing database
Detail: PostgreSQL already has full-text search built-in

Testing: 1/2
Reason: Unit + integration tests
Detail: Test search logic + test with real database

Security: 2/2
Reason: SQL injection risk, authentication required
Detail: User input in queries, must be authenticated to search
```

**Total: 5/10 → Blueprint Workflow**
**Estimated Time**: 30-45 minutes

### Implementation Plan

**Phase 1**: Database (10 min)
- Add full-text search index to products table
- Test query performance

**Phase 2**: API Route (15 min)
- Create `/api/products/search` endpoint
- Implement search service
- Add input validation

**Phase 3**: Testing (10 min)
- Unit tests for search logic
- Integration test with database
- Security: test SQL injection prevention

**Actual Time**: 38 minutes ✅ (within estimate)

---

## Example 3: "Add OAuth authentication system"

### Analysis

```
Technical Scope: 2/2
Reason: Frontend + backend + database
Detail: Login UI, OAuth callbacks, session management, user table

Architecture: 2/2
Reason: Entire authentication system
Detail: New auth middleware, session store, JWT handling

Dependencies: 2/2
Reason: OAuth library + session store + JWT
Detail: passport.js, express-session, jsonwebtoken, redis

Testing: 2/2
Reason: E2E + security + integration tests
Detail: Full login flow testing, security audits, session tests

Security: 2/2
Reason: Critical authentication handling
Detail: OAuth security, CSRF protection, session fixation, XSS
```

**Total: 10/10 → Epic Workflow**
**Estimated Time**: 2-3 hours, phased implementation

### Implementation Plan (PRD Required)

**Phase 1: Foundation** (30 min)
- Database schema (users, sessions)
- OAuth provider registration (Google, GitHub)
- Environment variables setup

**Phase 2: Backend Core** (45 min)
- Passport.js integration
- OAuth callbacks
- Session management
- JWT generation

**Phase 3: Frontend** (30 min)
- Login page UI
- OAuth redirect buttons
- Protected route HOC
- Session persistence

**Phase 4: Security** (30 min)
- CSRF protection
- Rate limiting
- Session timeout
- XSS prevention

**Phase 5: Testing** (45 min)
- E2E: Full login flow
- Security: Penetration testing
- Integration: Database + session tests

**Actual Time**: 2h 45min ✅ (within range)

---

## Example 4: "Create dashboard with charts"

### Analysis

```
Technical Scope: 1/2
Reason: Frontend mostly, API for data
Detail: Dashboard page, chart components, data API

Architecture: 1/2
Reason: New charting integration
Detail: Adding Chart.js (new library pattern)

Dependencies: 1/2
Reason: 1-2 charting libraries
Detail: react-chartjs-2, chart.js

Testing: 1/2
Reason: Unit + visual tests
Detail: Test data transformations, visual regression

Security: 0/2
Reason: Display only, authenticated route
Detail: No user input, just displaying data
```

**Total: 4/10 → Blueprint Workflow**
**Estimated Time**: 35-50 minutes

---

## Example 5: "Integrate Stripe payments"

### Analysis

```
Technical Scope: 2/2
Reason: Frontend + backend + webhooks
Detail: Payment form, Stripe API, webhook handling

Architecture: 2/2
Reason: New payment processing system
Detail: Webhooks, async payment confirmation, refunds

Dependencies: 2/2
Reason: Stripe SDK, webhook verification
Detail: @stripe/stripe-js, stripe (node), webhook signature

Testing: 2/2
Reason: E2E + security + edge cases
Detail: Test payment flow, failed payments, webhooks

Security: 2/2
Reason: Critical payment handling
Detail: PCI compliance, webhook security, idempotency
```

**Total: 10/10 → Epic Workflow**
**Estimated Time**: 3-4 hours, phased

---

## Lessons Learned

### Pattern 1: Security Adds Points

Even simple features score higher with security concerns:
- "Add contact form" (no validation) = 1/10
- "Add contact form" (with email validation) = 2/10
- "Add contact form" (store in database) = 3/10

**Takeaway**: Always consider security dimension

### Pattern 2: Dependencies Can Deceive

"Add real-time chat" sounds complex but:
- If using Socket.io = 8/10 (known library)
- If custom WebSocket = 10/10 (build from scratch)

**Takeaway**: Library choice affects complexity

### Pattern 3: Architecture Matters More Than Code

"Add 1000 lines of boilerplate" = 3/10 (repetitive)
"Add 50 lines of new pattern" = 7/10 (architectural)

**Takeaway**: Novel patterns > code volume

---

## Common Scoring Mistakes

### Mistake 1: Confusing Scope with Complexity

❌ "This touches 10 files, so it's 10/10"
✅ "10 files but same pattern repeated = 4/10"

### Mistake 2: Ignoring Testing

❌ "Simple feature, no testing needed"
✅ "Payment feature, extensive testing required"

### Mistake 3: Underestimating Integration

❌ "Just add Stripe, it's documented"
✅ "Stripe + webhooks + error handling = complex"

---

**Use these examples as calibration for your own scoring decisions.**
