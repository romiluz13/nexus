---
name: Debugging Methodology
description: |
  Execute systematic 5-phase debugging: Reproduce → Diagnose → Fix → Verify → Prevent.
  Handle bugs from syntax errors to complex runtime issues with structured approach.
  Activate when user mentions fixing, debugging, or resolving errors.
allowed-tools: Read, Write, Edit, Bash, mcp__ide__getDiagnostics
---

# Debugging Methodology

## Purpose

Execute structured debugging using proven 5-phase methodology. Transform bug reports into permanent fixes with prevention mechanisms.

## When to Activate

**Trigger Keywords:**
- "fix", "debug", "resolve", "broken", "not working", "failing"
- "error:", "exception:", "TypeError", "undefined"

**Examples:**
- "Fix the login error"
- "Debug API 500 errors"
- "Payment form broken"

**Disambiguation:**
- "Fix [error message]" → Activate (bug fixing)
- "Fix broken feature" → Activate (bug fixing)
- "Fix by adding X" → Defer to complexity-analyzer (feature addition)
- "Fix missing feature" → Defer to complexity-analyzer (feature is missing, not broken)
- Error stack trace present → Activate immediately
- "Not working" → Clarify if broken (bug) or missing (feature)

## The 5-Phase Methodology

### Phase 1: Reproduce & Understand (10% of time)

**Goal:** Confirm bug exists and understand failure conditions

**Process:**
1. Gather context (what, when, what changed)
2. Reproduce with exact steps
3. Capture error message/stack trace
4. Identify affected files and scope
5. Run diagnostics (getDiagnostics tool)

**Quick Win:** If diagnostics show obvious error → fix immediately, skip to Phase 4

**Output:**
```
🐛 Bug confirmed in [files]
📍 Scope: [frontend/backend/integration]
📊 Severity: [Critical/High/Medium/Low]
⏱️ Estimated: [X] minutes
```

### Phase 2: Diagnose Root Cause (40% of time)

**Goal:** Identify actual root cause, not symptoms

**Process:**
1. Analyze stack trace (bottom-up for original cause)
2. Trace data flow (where did it break?)
3. Check common culprits:
   - Null/undefined values
   - Type mismatches
   - Async issues (race conditions, missing await)
   - Scope problems
   - Configuration errors
   - Dependency issues
4. Form specific hypothesis

**Output:**
```
🔍 Root Cause: [Specific explanation]

Hypothesis: [What's wrong and why]
Fix Approach: [Solution strategy]
Files to Change: [file1, file2, ...]
```

### Phase 3: Fix Implementation (30% of time)

**Goal:** Minimal, correct fix addressing root cause

**Fix Principles:**
- Minimal change (fix only what's broken)
- Address cause, not symptoms
- No side effects
- Match existing code style

**Common Fix Patterns:**

**Null/Undefined:**
```typescript
// Problem: Cannot read property 'id' of undefined
// Fix: Optional chaining
const userId = user?.id ?? 'anonymous';
```

**Async/Await:**
```typescript
// Problem: Race condition
// Fix: Proper async/await
async function getData() {
  const response = await fetchAPI();
  return response.data;
}
```

**Type Mismatch:**
```typescript
// Problem: Expected string, got number
// Fix: Convert type
const id: string = String(user.id);
```

**Implementation Steps:**
1. Read file with bug
2. Locate exact problematic line
3. Apply fix with Edit tool
4. If multiple files, fix in dependency order

**Output:**
```
🔧 Applying fix...

Changes:
✏️ [file:line] - [description]

Fix Strategy: [Pattern used]
```

### Phase 4: Verify Fix (15% of time)

**Goal:** Confirm bug fixed, nothing else broke

**Verification Checklist:**
1. Run diagnostics (getDiagnostics)
2. TypeScript compiles without errors
3. Reproduce original failure → should now work
4. Test edge cases
5. Run existing tests (`npm test`)
6. Verify related functionality

**Quality Gates:**
- ✅ Original bug fixed
- ✅ No new errors
- ✅ TypeScript compiles
- ✅ Tests pass
- ✅ Related features work

**Output:**
```
✅ Verification Complete

✅ Original bug: FIXED
✅ TypeScript: No errors
✅ Tests: X/X passing
✅ Related features: Working
```

### Phase 5: Prevent Recurrence (5% of time)

**Goal:** Make bug impossible to recur

**Prevention Strategies:**

**1. Add Guard Clauses:**
```typescript
function getUsername(user) {
  if (!user) {
    throw new Error('User is required');
  }
  return user.name;
}
```

**2. Add Type Safety:**
```typescript
interface UserData {
  id: number;
  name: string;
  email: string;
}
function processData(data: UserData) { ... }
```

**3. Add Validation:**
```typescript
if (!req.body.email || !req.body.name) {
  return res.status(400).json({
    error: 'Missing required fields'
  });
}
```

**4. Add Regression Test:**
```typescript
it('should handle missing user gracefully', () => {
  const result = getUsername(null);
  expect(result).toBe('anonymous');
});
```

**5. Add Error Logging:**
```typescript
try {
  processPayment(amount);
} catch (error) {
  logger.error('Payment failed', { amount, userId, error });
  throw error;
}
```

**Output:**
```
🛡️ Prevention Measures:

- Guard clause added
- Type safety improved
- Validation added
- Test added
- Logging added

Bug should not recur.
```

## Bug Severity Classification

**🔴 Critical:** Production down, data loss, security
- Process: Fix immediately, thorough testing

**🟠 High:** Core feature broken, multiple users affected
- Process: Standard 5-phase, comprehensive testing

**🟡 Medium:** Edge case, minor feature broken
- Process: Standard 5-phase, focused testing

**🟢 Low:** Cosmetic, rare edge case
- Process: Quick fix, basic testing

## Edge Cases

**Intermittent Bugs:**
- Document reproduction frequency
- Add extensive logging
- Check race conditions
- Add retry logic

**Can't Reproduce:**
- Check production-only issues (env vars)
- Review logs for patterns
- Add more logging
- Document monitoring steps

**Multiple Related Bugs:**
- Fix root cause first
- Check if others disappear
- If independent, fix one at a time

**Unknown Codebase:**
- Use Grep extensively
- Read tests for expected behavior
- Follow stack trace
- Verify by reading code

## Examples

### Example 1: Null Error (5 minutes)

```
Phase 1: Reproduce ✅
- Error in user profile
- user object is null

Phase 2: Diagnose (2 min)
- Missing optional chaining

Phase 3: Fix (1 min)
- Add: user?.name ?? 'Guest'

Phase 4: Verify ✅
- Error gone

Phase 5: Prevent
- Add type: User | null
- Add test for null case
```

### Example 2: Production Bug (30 minutes)

```
Phase 1: Reproduce ❌
- Works locally, not production
- Check logs: missing env var

Phase 2: Diagnose (20 min)
- API_KEY not set in production

Phase 3: Fix (5 min)
- Add validation on startup
- Better error message

Phase 4: Verify ✅
- Set env var
- Error cleared

Phase 5: Prevent
- Add env validation
- Update deployment checklist
- Document in .env.example
```

## Integration

Coordinate with root-cause-analyzer skill for advanced diagnostics during Phase 2 (Diagnose).
Works with code-quality skills after fixing to ensure no code smells introduced.
May trigger refactoring-patterns if fix reveals deeper issues.

## Success Criteria

- ✅ 90%+ bugs fixed on first attempt
- ✅ No new bugs introduced
- ✅ Root cause identified
- ✅ All tests pass
- ✅ Prevention added
