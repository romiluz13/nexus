---
name: Test Coverage Improver
description: |
  Analyze test coverage gaps and generate targeted tests to improve coverage.
  Identify untested code paths, edge cases, and error scenarios. Prioritize
  high-value tests that catch real bugs. Activate when user wants better coverage.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, TodoWrite
---

# Test Coverage Improver

## Purpose

Systematically improve test coverage by identifying gaps and generating targeted tests. Focus on high-value tests that actually catch bugs, not just increasing coverage percentages.

## When to Activate

**Trigger Keywords:**
- "improve test coverage"
- "need more tests"
- "coverage is low"
- "add missing tests"
- "increase coverage"

**Examples:**
- "Test coverage is 45%, need to get to 80%"
- "Find what's not tested"
- "Add tests for uncovered code"

## Coverage Analysis Process

### Step 1: Generate Coverage Report

```bash
# Run tests with coverage
npm test -- --coverage

# Or specific framework commands
jest --coverage
vitest --coverage
```

**Coverage Metrics:**
- **Statements**: % of code lines executed
- **Branches**: % of if/else paths tested
- **Functions**: % of functions called
- **Lines**: % of lines executed

### Step 2: Identify Coverage Gaps

**High Priority Gaps (Test First):**
- Uncovered critical paths (auth, payments, data loss)
- Error handling not tested
- Edge cases missing (empty, null, max values)
- Business logic not covered

**Medium Priority:**
- Utility functions partially covered
- Some branches not tested
- Integration points not fully tested

**Low Priority:**
- UI rendering tests
- Trivial getters/setters
- Third-party library wrappers

### Step 3: Prioritize Tests

**Prioritization Formula:**
```
Priority = (Risk × Usage) / Effort

Risk: How bad if it breaks? (1-10)
Usage: How often executed? (1-10)
Effort: Time to write test (1-10, inverted)

High Priority: Score > 25
Medium Priority: Score 10-25
Low Priority: Score < 10
```

**Example:**
```
Function: processPayment()
Risk: 10 (money involved)
Usage: 10 (every purchase)
Effort: 5 (medium complexity)
Priority: (10 × 10) / 5 = 20 → High Priority
```

## Test Generation Strategies

### Strategy 1: Cover Untested Functions

**Analysis:**
```bash
# Find functions with 0% coverage
# Use coverage report to identify
```

**Generate Tests:**
```typescript
// Uncovered function
function calculateDiscount(price, couponCode) {
  if (couponCode === 'SAVE20') return price * 0.8;
  if (couponCode === 'SAVE10') return price * 0.9;
  return price;
}

// Generated tests
describe('calculateDiscount', () => {
  it('should apply 20% discount for SAVE20', () => {
    expect(calculateDiscount(100, 'SAVE20')).toBe(80);
  });

  it('should apply 10% discount for SAVE10', () => {
    expect(calculateDiscount(100, 'SAVE10')).toBe(90);
  });

  it('should return original price for invalid coupon', () => {
    expect(calculateDiscount(100, 'INVALID')).toBe(100);
  });

  it('should return original price for empty coupon', () => {
    expect(calculateDiscount(100, '')).toBe(100);
  });
});
```

### Strategy 2: Cover Missing Branches

**Analysis:**
```
Branch coverage: 60%
Missing branches:
- Line 45: if (user.role === 'admin') - FALSE branch not tested
- Line 67: if (balance < 0) - TRUE branch not tested
```

**Generate Tests:**
```typescript
// Missing branch: non-admin users
it('should deny access for non-admin users', () => {
  const user = { role: 'user' };
  expect(checkAdminAccess(user)).toBe(false);
});

// Missing branch: negative balance
it('should reject negative balance', () => {
  expect(validateBalance(-10)).toThrow('Balance cannot be negative');
});
```

### Strategy 3: Add Edge Case Tests

**Common Edge Cases:**
- Empty arrays/strings
- Null/undefined values
- Maximum/minimum values
- Boundary conditions
- Zero values

**Example:**
```typescript
describe('Edge Cases', () => {
  it('should handle empty array', () => {
    expect(calculateTotal([])).toBe(0);
  });

  it('should handle null input', () => {
    expect(processUser(null)).toThrow('User required');
  });

  it('should handle maximum value', () => {
    expect(validateAge(150)).toBe(false);
  });

  it('should handle boundary: age 18', () => {
    expect(isAdult(18)).toBe(true);
    expect(isAdult(17)).toBe(false);
  });
});
```

### Strategy 4: Add Error Handling Tests

**Identify Uncovered Error Paths:**
```typescript
// Function with error handling
async function fetchUserData(userId) {
  try {
    const response = await api.get(`/users/${userId}`);
    return response.data;
  } catch (error) {
    // This catch block not covered! ← Gap
    logger.error('Failed to fetch user', error);
    throw new Error('User not found');
  }
}

// Generated error test
it('should handle API failure', async () => {
  api.get = jest.fn().mockRejectedValue(new Error('Network error'));

  await expect(fetchUserData(123))
    .rejects.toThrow('User not found');

  expect(logger.error).toHaveBeenCalled();
});
```

## Test Quality Guidelines

### Write Meaningful Tests

**✅ Good Test:**
```typescript
it('should reject orders under minimum value', () => {
  const order = { total: 5, items: [...] };
  expect(validateOrder(order)).toEqual({
    valid: false,
    error: 'Order must be at least $10'
  });
});
```

**❌ Poor Test:**
```typescript
it('should work', () => {
  expect(validateOrder(someOrder)).toBeTruthy();
});
```

### Test Behavior, Not Implementation

**✅ Good (Tests behavior):**
```typescript
it('should display error message when login fails', () => {
  // User provides wrong password
  loginWithCredentials('user@example.com', 'wrongpass');

  // Error message should appear
  expect(screen.getByText('Invalid credentials')).toBeVisible();
});
```

**❌ Poor (Tests implementation):**
```typescript
it('should call setError with specific message', () => {
  // Too coupled to implementation details
  expect(setError).toHaveBeenCalledWith('Invalid credentials');
});
```

### Use AAA Pattern

**Arrange-Act-Assert:**
```typescript
it('should calculate total with tax', () => {
  // Arrange: Set up test data
  const items = [
    { price: 10 },
    { price: 20 }
  ];
  const taxRate = 0.08;

  // Act: Execute the function
  const result = calculateTotalWithTax(items, taxRate);

  // Assert: Verify the result
  expect(result).toBe(32.4); // 30 + 2.4 tax
});
```

## Coverage Improvement Workflow

### Step 1: Analyze Current Coverage

```bash
npm test -- --coverage

# Review report:
# - Overall coverage: 65%
# - Files with < 80% coverage: 15 files
# - Critical uncovered: auth.ts (45%), payment.ts (60%)
```

### Step 2: Create Test Plan

```
Priority 1 (Critical):
1. auth.ts: Add error handling tests (10 min)
2. payment.ts: Add edge case tests (15 min)

Priority 2 (High Value):
3. user-service.ts: Cover missing branches (10 min)
4. validation.ts: Add null/undefined tests (5 min)

Priority 3 (Nice to Have):
5. utils.ts: Complete utility function tests (15 min)

Total Estimated: 55 minutes to reach 80% coverage
```

### Step 3: Generate Tests with TodoWrite

```
[TodoWrite checklist:]
1. ✅ auth.ts error handling (10 min)
2. 🔄 payment.ts edge cases (15 min)
3. ⏳ user-service.ts branches
4. ⏳ validation.ts null checks
5. ⏳ utils.ts completeness
```

### Step 4: Verify Coverage Improvement

```bash
# After adding tests
npm test -- --coverage

# Compare:
# Before: 65% coverage
# After: 84% coverage (+19%)
# Files < 80%: 15 → 3 files
```

## Integration Testing Gaps

**Common Integration Gaps:**
- API endpoints tested, but not error responses
- Database operations tested, but not transactions
- Authentication tested, but not authorization
- Happy path tested, but not edge cases

**Example Integration Test:**
```typescript
describe('POST /api/orders', () => {
  // Happy path likely already tested ✅

  // Missing tests ❌
  it('should return 400 for invalid order data', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({ invalidData: true });

    expect(response.status).toBe(400);
    expect(response.body.error).toBeDefined();
  });

  it('should return 401 for unauthenticated requests', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send(validOrder);

    expect(response.status).toBe(401);
  });

  it('should rollback transaction on failure', async () => {
    // Mock database failure
    db.save = jest.fn().mockRejectedValue(new Error('DB error'));

    await request(app).post('/api/orders').send(validOrder);

    // Verify order not saved
    const orders = await db.orders.findAll();
    expect(orders).toHaveLength(0);
  });
});
```

## Output Format

```
📊 Coverage Analysis

Current Coverage: 65%
Target: 80%
Gap: 15%

🔍 Coverage Gaps Identified:

🔴 Critical (Must Fix):
   - auth.ts: 45% coverage
     Missing: Error handling, token validation
     Effort: 10 minutes
     Tests to Add: 5

   - payment.ts: 60% coverage
     Missing: Refund flow, failed payments
     Effort: 15 minutes
     Tests to Add: 7

🟡 High Value:
   - user-service.ts: 72% coverage
     Missing: Admin role checks
     Effort: 10 minutes
     Tests to Add: 4

📋 Test Generation Plan:

Phase 1 (Critical): 25 minutes
   1. auth.ts error handling
   2. payment.ts edge cases

Phase 2 (High Value): 10 minutes
   3. user-service.ts branches

⏱️ Estimated Time to 80%: 35 minutes
📝 Total Tests to Add: 16

Starting test generation...
```

## Integration

Works after feature implementation or refactoring to ensure adequate test coverage.
Coordinates with refactoring-patterns to test refactored code.
Provides gap analysis that guides systematic test generation.

## Success Criteria

- ✅ Coverage increased by target amount
- ✅ High-risk code paths tested
- ✅ Error scenarios covered
- ✅ Edge cases tested
- ✅ All generated tests pass
- ✅ Tests are meaningful (not just coverage padding)
