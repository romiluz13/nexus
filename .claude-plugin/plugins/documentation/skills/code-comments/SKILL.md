---
name: Code Comments
description: |
  Add clear, helpful inline code comments and JSDoc/TSDoc documentation. Focus on
  why over what, document complex logic, and create function documentation. Activate
  when user needs code-level documentation or comments.
allowed-tools: Read, Write, Edit
---

# Code Comments

## Purpose

Add meaningful inline documentation that explains intent, documents functions, and helps future developers understand the code.

## When to Activate

**Trigger Keywords:**
- "add comments"
- "document this code"
- "add JSDoc"
- "explain this function"
- "add inline documentation"

**Examples:**
- "Add comments to this function"
- "Document these utility functions"
- "Add JSDoc comments"

## Comment Guidelines

### Golden Rule: Explain WHY, Not WHAT

**✅ Good (Explains why):**
```typescript
// Use exponential backoff to avoid overwhelming the API during failures
await retryWithBackoff(apiCall);
```

**❌ Poor (States obvious):**
```typescript
// Call the retry function
await retryWithBackoff(apiCall);
```

### When to Add Comments

**DO Comment:**
- Complex logic that's not immediately clear
- Non-obvious algorithms
- Business rules and constraints
- Workarounds for bugs/limitations
- Performance optimizations
- Security considerations

**DON'T Comment:**
- Obvious code that explains itself
- What the code does (if clear from function names)
- Outdated information
- Commented-out code (delete it)

## JSDoc/TSDoc Format

### Function Documentation

**Template:**
```typescript
/**
 * Brief description of what the function does
 *
 * @param paramName - Description of parameter
 * @param options - Configuration options
 * @param options.timeout - Request timeout in milliseconds
 * @returns Description of return value
 * @throws {ErrorType} When this error occurs
 *
 * @example
 * const result = await fetchUser(123, { timeout: 5000 });
 * console.log(result.name);
 */
async function fetchUser(
  userId: number,
  options: { timeout?: number } = {}
): Promise<User> {
  // Implementation
}
```

### Class Documentation

**Template:**
```typescript
/**
 * Manages user authentication and session handling
 *
 * Handles JWT token generation, validation, and refresh.
 * Stores sessions in Redis for fast lookup.
 *
 * @example
 * const auth = new AuthService();
 * const token = await auth.login('user@example.com', 'password');
 */
class AuthService {
  /**
   * Authenticates user and generates JWT token
   *
   * @param email - User's email address
   * @param password - Plain text password (hashed internally)
   * @returns JWT token valid for 24 hours
   * @throws {AuthError} If credentials invalid
   */
  async login(email: string, password: string): Promise<string> {
    // Implementation
  }
}
```

### Interface/Type Documentation

**Template:**
```typescript
/**
 * Represents a user in the system
 */
interface User {
  /** Unique user identifier */
  id: number;

  /** User's email address (must be unique) */
  email: string;

  /** Display name for the user */
  name: string;

  /** User's role (affects permissions) */
  role: 'admin' | 'user' | 'guest';

  /**
   * Account creation timestamp
   * @format ISO 8601 date string
   */
  createdAt: string;
}
```

## Inline Comment Patterns

### Pattern 1: Business Logic Explanation

```typescript
function calculateDiscount(price: number, userTier: string): number {
  // Premium users get 20% discount to encourage subscription renewal
  if (userTier === 'premium') {
    return price * 0.8;
  }

  // First-time users get 10% discount to improve conversion rate
  if (userTier === 'new') {
    return price * 0.9;
  }

  return price;
}
```

### Pattern 2: Complex Algorithm

```typescript
function findShortestPath(graph: Graph, start: Node, end: Node): Path {
  // Using A* algorithm for optimal pathfinding
  // Complexity: O(E log V) where E=edges, V=vertices
  const openSet = new PriorityQueue();
  const closedSet = new Set();

  // Initialize with start node (g_score = 0, f_score = heuristic)
  openSet.add(start, heuristic(start, end));

  while (!openSet.isEmpty()) {
    const current = openSet.poll();

    // Goal reached, reconstruct path
    if (current === end) {
      return reconstructPath(current);
    }

    // ...
  }
}
```

### Pattern 3: Workaround Documentation

```typescript
async function uploadFile(file: File): Promise<string> {
  // WORKAROUND: Safari doesn't support FormData.entries()
  // Using older method for compatibility until Safari 16 adoption > 95%
  // TODO: Remove after Q2 2026 (ticket #4567)
  const formData = new FormData();
  if (isSafari()) {
    // Legacy approach
  } else {
    // Modern approach
  }
}
```

### Pattern 4: Security Notes

```typescript
function sanitizeInput(userInput: string): string {
  // SECURITY: Strip HTML tags to prevent XSS attacks
  // Using DOMPurify library for comprehensive sanitization
  return DOMPurify.sanitize(userInput, {
    ALLOWED_TAGS: [], // No tags allowed
    ALLOWED_ATTR: []
  });
}
```

### Pattern 5: Performance Notes

```typescript
function processLargeDataset(data: any[]): Result {
  // PERFORMANCE: Process in chunks to avoid blocking event loop
  // Chunk size of 1000 optimized through profiling (see benchmark #234)
  const CHUNK_SIZE = 1000;

  for (let i = 0; i < data.length; i += CHUNK_SIZE) {
    const chunk = data.slice(i, i + CHUNK_SIZE);
    processChunk(chunk);
  }
}
```

## Comment Quality Checklist

### High-Quality Comments

- ✅ **Clear:** Easy to understand
- ✅ **Concise:** No unnecessary words
- ✅ **Accurate:** Matches the code
- ✅ **Maintained:** Updated with code changes
- ✅ **Useful:** Provides value beyond reading code

### Low-Quality Comments (Avoid)

- ❌ **Obvious:** `// Increment counter` → `counter++;`
- ❌ **Outdated:** Comments don't match code
- ❌ **Redundant:** Repeats variable/function names
- ❌ **Vague:** "Handle the case" (which case?)
- ❌ **Commented code:** Delete it, git remembers

## Special Comment Types

### TODO Comments

**Format:**
```typescript
// TODO: Add rate limiting to prevent abuse
// TODO(username): Refactor after API v2 release
// TODO [JIRA-123]: Implement caching layer
```

### FIXME Comments

**Format:**
```typescript
// FIXME: Memory leak when processing > 10,000 items
// FIXME: Race condition on concurrent writes
```

### HACK Comments

**Format:**
```typescript
// HACK: Temporary workaround for Safari bug (remove after Safari 17)
```

### NOTE Comments

**Format:**
```typescript
// NOTE: Order matters - validation must happen before transformation
```

## Documentation Workflow

### Step 1: Identify What Needs Comments

**Scan for:**
- Public APIs (functions/classes)
- Complex algorithms
- Non-obvious logic
- Business rules
- Edge cases

### Step 2: Analyze Function Purpose

**Ask:**
- What does it do?
- Why does it exist?
- What are inputs/outputs?
- What errors can occur?
- What assumptions exist?

### Step 3: Write Documentation

**Priority Order:**
1. Public API functions (JSDoc)
2. Complex logic (inline comments)
3. Business rules (inline comments)
4. Edge cases (inline comments)

### Step 4: Review for Quality

**Check:**
- Spelling and grammar
- Accuracy (matches code)
- Clarity (easy to understand)
- Completeness (all params documented)

## Output Format

```typescript
/**
 * Processes user payment with fraud detection
 *
 * Validates payment method, checks for fraud patterns, and processes
 * charge through payment gateway. Automatically retries failed payments
 * up to 3 times with exponential backoff.
 *
 * @param userId - The ID of the user making the payment
 * @param amount - Payment amount in cents (e.g., 1000 = $10.00)
 * @param paymentMethod - Payment method details (card or bank account)
 * @param options - Optional configuration
 * @param options.retryAttempts - Number of retry attempts (default: 3)
 * @param options.fraudCheckLevel - Fraud detection level ('standard' | 'strict')
 *
 * @returns Payment confirmation with transaction ID
 *
 * @throws {ValidationError} If amount <= 0 or payment method invalid
 * @throws {FraudError} If transaction flagged as fraudulent
 * @throws {PaymentError} If payment gateway rejects the charge
 *
 * @example
 * const result = await processPayment(
 *   123,
 *   5000,
 *   { type: 'card', token: 'tok_abc123' },
 *   { fraudCheckLevel: 'strict' }
 * );
 * console.log(`Transaction ID: ${result.transactionId}`);
 */
async function processPayment(
  userId: number,
  amount: number,
  paymentMethod: PaymentMethod,
  options: PaymentOptions = {}
): Promise<PaymentResult> {
  // Validate amount meets minimum threshold
  // Prevents processing fees exceeding payment value
  if (amount < 100) {
    throw new ValidationError('Minimum payment is $1.00');
  }

  // Run fraud detection before charging
  // SECURITY: Prevents fraudulent transactions
  const fraudScore = await detectFraud(userId, amount, paymentMethod);
  if (fraudScore > FRAUD_THRESHOLD) {
    await notifyFraudTeam(userId, fraudScore);
    throw new FraudError('Transaction flagged for review');
  }

  // Process charge with retry logic
  // WORKAROUND: Gateway occasionally returns 503 under load
  const result = await retryWithBackoff(
    () => gateway.charge(amount, paymentMethod),
    options.retryAttempts ?? 3
  );

  return result;
}
```

## Integration

Coordinate with api-documentation for API-level docs.
Works with architecture-docs for system-level documentation.

## Success Criteria

- ✅ All public functions have JSDoc
- ✅ Complex logic explained
- ✅ Business rules documented
- ✅ Security notes where relevant
- ✅ Performance considerations noted
- ✅ Comments explain WHY, not WHAT
