---
name: Root Cause Analyzer
description: |
  Advanced diagnostic techniques for identifying root causes. Master stack trace
  analysis, grep strategies, pattern recognition, and data flow tracing. Works with
  debugging-methodology skill to diagnose complex bugs.
allowed-tools: Grep, Read, Bash
---

# Root Cause Analyzer

## Purpose

Provide advanced diagnostic capabilities for identifying root causes of bugs. Use pattern recognition, strategic grep, and data flow analysis to pinpoint exact failure points.

## When to Activate

Activate during Phase 2 (Diagnose) of debugging-methodology when root cause is not immediately obvious.

## Diagnostic Techniques

### Stack Trace Analysis

**Read Bottom-Up** (original cause first):

```
Error: Cannot read property 'id' of undefined
    at processUser (user-service.ts:45)      ← Symptom
    at handleRequest (api.ts:120)            ← Propagation
    at app.post (server.ts:89)               ← Entry point

→ Start at line 45 in user-service.ts (actual problem)
```

**Identify Exact Failure:**
- Which function threw error?
- What line number?
- What was the operation? (property access, function call, etc.)
- What data caused it? (null, undefined, wrong type)

### Data Flow Tracing

**Map the Journey:**
```
User Action
    ↓
Event Handler (onClick, onSubmit)
    ↓
State Update (setState, dispatch)
    ↓
API Call (fetch, axios)
    ↓
Response Processing
    ↓
UI Update

WHERE DID IT BREAK? ← Find this link
```

**Questions to Ask:**
- What data enters the chain?
- What transformation happens at each step?
- Where does data become null/undefined/wrong?
- Which step assumptions fail?

### Common Culprits Checklist

**1. Null/Undefined (40% of bugs):**
```typescript
// Missing data
const name = user.name; // user is undefined

// Optional property
const email = user.profile.email; // profile is undefined

// Array element
const first = items[0]; // items is empty
```

**Fix Pattern:** Optional chaining, guard clauses, default values

**2. Type Mismatch (25% of bugs):**
```typescript
// String vs Number
const id: string = user.id; // id is number

// Object vs Array
items.map() // items is object, not array

// Parsing failure
const data = JSON.parse(response); // response is not JSON
```

**Fix Pattern:** Type conversion, validation, type guards

**3. Async Issues (20% of bugs):**
```typescript
// Missing await
const data = fetchData(); // Returns promise, not data
return data.results;

// Race condition
function handleClick() {
  fetchData(); // Not awaited
  setState(data); // data not ready yet
}

// Unhandled rejection
fetch(url).then(); // No catch
```

**Fix Pattern:** async/await, promise chaining, error handling

**4. Scope Issues (10% of bugs):**
```typescript
// Variable not in scope
function outer() {
  const value = 42;
}
console.log(value); // value not defined

// Closure stale reference
for (var i = 0; i < 5; i++) {
  setTimeout(() => console.log(i), 100); // Always prints 5
}
```

**Fix Pattern:** Proper scoping, let instead of var, closure awareness

**5. Configuration Errors (5% of bugs):**
```typescript
// Missing env var
const apiKey = process.env.API_KEY; // undefined

// Wrong endpoint
const url = '/api/v1/users'; // Should be /api/v2/users

// Port conflicts
app.listen(3000); // Port already in use
```

**Fix Pattern:** Validation, environment checks, error messages

## Strategic Grep Usage

### Finding Error Origins

**Search for Error Message:**
```bash
# Find where error is thrown
Grep: pattern="Cannot find user" path="src/" output_mode="content"

# Find error handling
Grep: pattern="catch.*user" path="src/" output_mode="content"
```

### Finding Function Definitions

**Locate Broken Function:**
```bash
# Find function definition
Grep: pattern="function processPayment" path="src/" -n output_mode="content"

# Find all usages
Grep: pattern="processPayment\\(" path="src/" output_mode="files_with_matches"
```

### Finding Similar Working Code

**Learn from Patterns:**
```bash
# Find successful similar implementations
Grep: pattern="findUser.*success" path="src/" output_mode="content"

# Find how others handle null
Grep: pattern="user\\?\\." path="src/" output_mode="content"
```

### Finding Recent Changes

**Check Git History:**
```bash
# Show recent changes to file
git log -p --since="1 week ago" -- path/to/file.ts

# Find when bug was introduced
git blame path/to/file.ts
```

## Pattern Recognition

### Learning from Previous Bugs

**Build Mental Database:**
```
Pattern: "TypeError: Cannot read property 'X' of undefined"
→ Likely Cause: Missing optional chaining
→ First Check: Use grep for "object.property" without "?."
→ Quick Fix: Add optional chaining or guard clause

Pattern: "UnhandledPromiseRejectionWarning"
→ Likely Cause: Missing .catch() or try/catch with await
→ First Check: Search for async functions without error handling
→ Quick Fix: Add proper error handling

Pattern: "EADDRINUSE: address already in use"
→ Likely Cause: Port conflict or zombie process
→ First Check: `lsof -i :PORT` to find process
→ Quick Fix: Kill process or change port
```

### Bug Signatures

**Recognize by Symptoms:**

**Intermittent Bugs:**
- Symptoms: Works sometimes, fails randomly
- Likely Cause: Race condition, timing issue
- Diagnosis: Add logging around suspected code
- Fix: Proper async handling, request cancellation

**Production-Only Bugs:**
- Symptoms: Works locally, fails in production
- Likely Cause: Environment differences (env vars, configs)
- Diagnosis: Compare environments, check logs
- Fix: Add validation, document requirements

**Data-Dependent Bugs:**
- Symptoms: Fails with specific data, works with test data
- Likely Cause: Edge cases, validation gaps
- Diagnosis: Test with production-like data
- Fix: Add validation, handle edge cases

## Context-Aware Analysis

**Load Minimal Context:**

**Frontend Bug:**
- Load: UI component patterns, state management
- Focus: Component lifecycle, event handling, state updates
- Tokens: ~5k

**Backend Bug:**
- Load: API patterns, database schema
- Focus: Request handling, data validation, database operations
- Tokens: ~5k

**Integration Bug:**
- Load: API contracts, both frontend and backend patterns
- Focus: Request/response format, data transformation
- Tokens: ~8k

## Hypothesis Formation

**Build Testable Hypothesis:**

**Template:**
```
What: [Specific error or failure]
Why: [Root cause mechanism]
How to Fix: [Specific solution]
How to Verify: [Test that proves fix works]
```

**Example:**
```
What: TypeError on user.profile.email
Why: profile property is undefined for new users
How to Fix: Add optional chaining: user.profile?.email
How to Verify: Create new user, check no error thrown
```

## Parallel Diagnosis

**For Multi-File Bugs:**

1. Identify all affected files with Grep
2. Diagnose primary failure point first
3. Trace dependencies
4. Prioritize fixes by dependency order
5. Apply fixes in parallel where independent

**Example:**
```
Bug affects: auth.ts, middleware.ts, database.ts

Diagnosis:
1. database.ts: Query returns null (root cause)
2. middleware.ts: Doesn't handle null response
3. auth.ts: Crashes on null from middleware

Fix Order:
1. Fix database.ts (returns empty array instead)
2. Parallel: Fix middleware.ts AND auth.ts
```

## Advanced Techniques

### Binary Search Debugging

**For "When did this break?" questions:**

```bash
# Git bisect to find breaking commit
git bisect start
git bisect bad  # Current broken state
git bisect good <last-known-good-commit>
# Test each commit Git provides
git bisect good/bad
```

### Rubber Duck Debugging

**When stuck, explain out loud:**
```
"This function receives user data...
Wait, where does user data come from?
Oh! The API returns undefined when user doesn't exist.
That's the problem!"
```

### Divide and Conquer

**Isolate the problem:**
1. Comment out half the code
2. Does bug still occur?
3. If yes, problem is in uncommented half
4. If no, problem is in commented half
5. Repeat until isolated to single line

## Output Format

```
🔍 Root Cause Analysis

📋 Evidence:
   Stack Trace: [formatted trace]
   Failed At: [file:line]
   Operation: [what was attempted]

🎯 Root Cause:
   [Specific explanation of mechanism]

🔬 Confidence: [High/Medium/Low]

💡 Hypothesis:
   Problem: [What's wrong]
   Why: [Underlying cause]
   Fix: [Solution approach]

📁 Files to Change:
   1. [file1] - [specific change]
   2. [file2] - [specific change]
```

## Integration

Called by debugging-methodology skill during Phase 2 (Diagnose).
Provides advanced diagnostic techniques including stack trace analysis, grep strategies, and pattern recognition.
Outputs hypothesis that guides Phase 3 (Fix Implementation).

## Success Criteria

- ✅ Correctly identify root cause 90%+ of time
- ✅ Diagnosis time under 40% of total fix time
- ✅ Hypothesis proves correct on implementation
- ✅ No symptom-only fixes
- ✅ Clear explanation of failure mechanism
