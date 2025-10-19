---
name: Refactoring Patterns
description: |
  Execute safe, incremental refactoring using proven patterns. Extract functions,
  remove duplication, simplify conditionals, improve naming. Guarantees functionality
  preservation with automated verification. Activate after code-smell-detector.
allowed-tools: Read, Write, Edit, Bash, TodoWrite
---

# Refactoring Patterns

## Purpose

Apply systematic refactoring patterns safely. Improve code quality through incremental changes with continuous verification.

## When to Activate

After code-smell-detector identifies issues, or when user requests specific refactoring.

**Trigger Keywords:**
- "refactor", "clean up", "improve", "simplify", "extract"

**Examples:**
- "Refactor this messy code"
- "Clean up the validation logic"
- "Simplify these conditionals"

**Disambiguation:**
- "Improve code quality" → Activate (quality improvement)
- "Improve feature X" → Defer to complexity-analyzer (feature enhancement)
- After code-smell-detector identifies issues → Activate to apply fixes
- User mentions specific pattern (e.g., "extract function") → Activate directly

## Refactoring Safety Protocol

### Golden Rules

1. **Tests must pass** before starting
2. **One change at a time** (single refactoring per step)
3. **Verify immediately** after each change
4. **Preserve functionality** (no behavior changes)
5. **Rollback on failure** (don't continue if tests fail)

### Risk Classification

**🟢 Safe (Low Risk):**
- Rename variables/functions
- Extract constants
- Add/improve comments
- Format code
→ Quick changes, minimal testing

**🟡 Moderate (Medium Risk):**
- Extract functions
- Remove duplication
- Simplify conditionals
→ Run tests after each change

**🔴 Complex (High Risk):**
- Restructure architecture
- Change interfaces
- Move responsibilities
→ Comprehensive testing, incremental approach

## Core Refactoring Patterns

### Pattern 1: Extract Function

**When to Use:**
- Function > 50 lines
- Multiple responsibilities
- Repeated code blocks
- Complex logic needs naming

**How to Apply:**
```typescript
// Before: Long function doing multiple things
function processOrder(order) {
  // Validation (10 lines)
  if (!order.items) throw new Error('No items');
  if (order.items.length === 0) throw new Error('Empty order');
  // ... more validation

  // Calculation (15 lines)
  const subtotal = order.items.reduce((sum, item) => sum + item.price, 0);
  const tax = subtotal * 0.08;
  // ... more calculation

  // Persistence (10 lines)
  database.save(order);
  emailService.send(order);
  // ... more persistence
}

// After: Extracted functions
function processOrder(order) {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  saveOrder(order, total);
}

function validateOrder(order) {
  if (!order.items) throw new Error('No items');
  if (order.items.length === 0) throw new Error('Empty order');
}

function calculateOrderTotal(order) {
  const subtotal = order.items.reduce((sum, item) => sum + item.price, 0);
  const tax = subtotal * 0.08;
  return subtotal + tax;
}

function saveOrder(order, total) {
  database.save({ ...order, total });
  emailService.send(order);
}
```

**Benefits:** Clear responsibilities, easier testing, better naming

### Pattern 2: Extract Constant

**When to Use:**
- Magic numbers/strings
- Repeated values
- Configurable values

**How to Apply:**
```typescript
// Before: Magic numbers
if (price > 100 && quantity >= 5 && discount < 0.2) {
  applyBulkDiscount();
}

// After: Named constants
const HIGH_VALUE_THRESHOLD = 100;
const BULK_QUANTITY_THRESHOLD = 5;
const MAX_DISCOUNT_RATE = 0.2;

if (price > HIGH_VALUE_THRESHOLD &&
    quantity >= BULK_QUANTITY_THRESHOLD &&
    discount < MAX_DISCOUNT_RATE) {
  applyBulkDiscount();
}
```

**Benefits:** Self-documenting, easy to update, consistent values

### Pattern 3: Simplify Conditional

**When to Use:**
- Deep nesting (> 3 levels)
- Complex boolean expressions
- Multiple conditions

**How to Apply:**

**A) Early Returns:**
```typescript
// Before: Nested conditions
function canPurchase(user, product) {
  if (user) {
    if (user.isActive) {
      if (user.balance >= product.price) {
        if (product.stock > 0) {
          return true;
        }
      }
    }
  }
  return false;
}

// After: Early returns
function canPurchase(user, product) {
  if (!user) return false;
  if (!user.isActive) return false;
  if (user.balance < product.price) return false;
  if (product.stock <= 0) return false;
  return true;
}
```

**B) Extract to Function:**
```typescript
// Before: Complex expression
if (user.age >= 18 && user.hasLicense && !user.hasSuspension &&
    user.yearsExperience >= 2 && user.violations < 3) {
  allowRentalCar();
}

// After: Named function
function isEligibleForCarRental(user) {
  return user.age >= 18 &&
         user.hasLicense &&
         !user.hasSuspension &&
         user.yearsExperience >= 2 &&
         user.violations < 3;
}

if (isEligibleForCarRental(user)) {
  allowRentalCar();
}
```

**Benefits:** Reduced cognitive load, better readability

### Pattern 4: Remove Duplication (DRY)

**When to Use:**
- Identical code in multiple places
- Similar patterns with slight variations

**How to Apply:**
```typescript
// Before: Duplicated logic
function processUserOrder(user, order) {
  validateUser(user);
  validateOrder(order);
  const total = order.items.reduce((sum, item) => sum + item.price, 0);
  const tax = total * 0.08;
  saveOrder(order, total + tax);
}

function processGuestOrder(guest, order) {
  validateGuest(guest);
  validateOrder(order);
  const total = order.items.reduce((sum, item) => sum + item.price, 0);
  const tax = total * 0.08;
  saveOrder(order, total + tax);
}

// After: Extracted common logic
function calculateOrderWithTax(order) {
  const total = order.items.reduce((sum, item) => sum + item.price, 0);
  return total + (total * 0.08);
}

function processUserOrder(user, order) {
  validateUser(user);
  validateOrder(order);
  const finalTotal = calculateOrderWithTax(order);
  saveOrder(order, finalTotal);
}

function processGuestOrder(guest, order) {
  validateGuest(guest);
  validateOrder(order);
  const finalTotal = calculateOrderWithTax(order);
  saveOrder(order, finalTotal);
}
```

**Benefits:** Single source of truth, easier maintenance

### Pattern 5: Improve Naming

**When to Use:**
- Unclear variable names
- Abbreviated names
- Non-descriptive names

**How to Apply:**
```typescript
// Before: Poor naming
function calc(d, r) {
  const x = d * r;
  return x;
}
const val = calc(100, 0.1);

// After: Clear naming
function calculateDiscount(amount, rate) {
  const discount = amount * rate;
  return discount;
}
const discountAmount = calculateDiscount(100, 0.1);
```

**Benefits:** Self-documenting code, less need for comments

## Refactoring Workflow

### Step 1: Baseline Check

```bash
# Ensure clean starting point
npm test                    # All tests pass
npm run typecheck           # No TypeScript errors
npm run lint                # No linting errors
```

### Step 2: Apply Single Refactoring

1. Read target file
2. Make ONE refactoring change using Edit tool
3. Save change

### Step 3: Verify Immediately

```bash
npm run typecheck           # TypeScript happy?
npm test                    # Tests still passing?
```

**If verification fails:**
- STOP - don't continue
- Revert the change
- Analyze what broke
- Try smaller change or skip

### Step 4: Update Progress

Mark completed in TodoWrite, move to next refactoring

### Step 5: Checkpoint Every 3 Changes

```bash
# After 3 successful refactorings
npm test                    # Full test suite
npm run typecheck           # Complete type check
# Create mental checkpoint
```

## Context-Aware Refactoring

**React Projects:**
- Extract custom hooks
- Component composition
- Props destructuring
- Memoization patterns

**Node.js APIs:**
- Middleware extraction
- Route handler patterns
- Error handling consistency
- Validation patterns

**TypeScript:**
- Type extraction
- Interface definitions
- Enum usage
- Generic patterns

## Edge Cases

**Legacy Code Without Tests:**
1. Write characterization tests first (document current behavior)
2. Then refactor incrementally
3. Expand test coverage as refactoring proceeds

**Breaking Changes Required:**
1. Document breaking changes
2. Provide migration guide
3. Version bump appropriately
4. Consider deprecation path

**Performance-Critical Code:**
1. Benchmark before refactoring
2. Refactor for clarity
3. Benchmark after
4. Ensure no regression (or explain trade-offs)

**Can't Improve Without Major Changes:**
1. Document ideal state
2. Make minimal improvements now
3. Create tech debt ticket
4. Don't let perfect be enemy of good

## Output Format

### During Execution

```
🔄 Executing Refactoring...

[TodoWrite checklist with real-time progress]

Step 1/8: ✅ Extract validateOrderItems
   - Created function (12 lines)
   - Tests: ✅ 45/45 passing
   - TypeScript: ✅ No errors

Step 2/8: 🔄 Extract calculateSubtotal
   ...
```

### At Completion

```
✨ Refactoring Complete

📊 Improvements:
   📉 Lines of code: 287 → 215 (-25%)
   📉 Avg function length: 42 → 18 lines (-57%)
   📉 Max nesting: 4 → 2 levels (-50%)
   📉 Duplications: 3 → 0 (-100%)
   📈 Test coverage: 85% → 92% (+7%)

✅ Quality Metrics:
   ✅ All tests: 45/45 passing
   ✅ TypeScript: 0 errors
   ✅ Lint: 0 warnings
   ✅ Cyclomatic complexity: 12 → 6

📁 Files Modified: 3
   - src/orders/process.ts
   - src/orders/validation.ts
   - src/orders/calculations.ts
```

## Integration

Receive code smells from code-smell-detector.
Apply patterns based on detected issues.
Verify after each change.
Report improvements.

## Success Criteria

- ✅ All tests pass before and after
- ✅ TypeScript compiles without errors
- ✅ Functionality unchanged
- ✅ Code quality metrics improved
- ✅ No new issues introduced
