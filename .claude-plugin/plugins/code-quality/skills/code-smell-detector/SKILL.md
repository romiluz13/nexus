---
name: Code Smell Detector
description: |
  Detect code quality issues and code smells. Identify long functions, deep nesting,
  duplication, magic numbers, poor naming, and complexity issues. Provides severity
  classification and improvement recommendations.
allowed-tools: Read, Grep, Glob, mcp__ide__getDiagnostics
---

# Code Smell Detector

## Purpose

Automatically detect code quality issues using pattern recognition. Classify problems by severity and provide actionable improvement recommendations.

## When to Activate

Activate before refactoring or when user requests code quality analysis.

**Trigger Keywords:**
- "analyze code quality"
- "find code smells"
- "what's wrong with this code"
- "code review"

**Examples:**
- "Analyze code quality in this file"
- "Find code smells in the API layer"
- "Review this code for issues"

**Disambiguation:**
- "Find issues" → Activate (detection only)
- "Fix code quality" → Activate for detection, then pass to refactoring-patterns for fixes
- "What's wrong" → Activate (diagnostic phase)
- "Make it better" → If asking about quality issues, activate; if about features, defer to complexity-analyzer

## Code Smells Catalog

### 1. Long Functions (High Priority)

**Detection:**
- Function > 50 lines
- Method > 30 lines for classes

**Why It's Bad:**
- Hard to understand
- Difficult to test
- Multiple responsibilities

**Fix:** Extract smaller functions

**Example:**
```typescript
// Detected: processOrder() - 87 lines
// Severity: 🔴 High
// Recommendation: Extract 4 functions
```

### 2. Deep Nesting (High Priority)

**Detection:**
- Indentation > 3 levels
- Nested if/for/while chains

**Why It's Bad:**
- Cognitive load
- Hard to follow logic
- Error-prone

**Fix:** Early returns, extract functions, flatten structure

**Example:**
```typescript
// Detected: validateUser() - 5 nesting levels
// Severity: 🔴 High
// Recommendation: Use early returns
```

### 3. Code Duplication (High Priority)

**Detection:**
- Identical code blocks > 5 lines
- Similar patterns in multiple files

**Why It's Bad:**
- Maintenance burden
- Bug multiplication
- Inconsistency risk

**Fix:** Extract shared functions, create utilities

**Example:**
```typescript
// Detected: calculateTotal() - 3 identical implementations
// Severity: 🔴 High
// Recommendation: Create shared utility function
```

### 4. Magic Numbers (Medium Priority)

**Detection:**
- Hardcoded numeric/string values
- No named constants

**Why It's Bad:**
- Unclear meaning
- Hard to update
- Inconsistency

**Fix:** Extract named constants

**Example:**
```typescript
// Before: if (price > 100 && quantity >= 5)
// Detected: 2 magic numbers
// Severity: 🟡 Medium
// Recommendation: Extract BULK_ORDER_THRESHOLD, HIGH_VALUE_THRESHOLD
```

### 5. Poor Naming (Medium Priority)

**Detection:**
- Single-letter variables (except loops)
- Abbreviations: temp, x, data, val
- Non-descriptive: handle(), process()

**Why It's Bad:**
- Unclear intent
- Requires comments
- Maintenance difficulty

**Fix:** Rename to descriptive names

**Example:**
```typescript
// Detected: Variable 'x' - unclear purpose
// Severity: 🟡 Medium
// Recommendation: Rename to 'totalPrice' or 'userCount'
```

### 6. God Objects (High Priority)

**Detection:**
- Class > 500 lines
- Module > 300 lines
- Too many methods (> 15)

**Why It's Bad:**
- Single Responsibility violated
- Hard to test
- Tight coupling

**Fix:** Split into focused modules/classes

**Example:**
```typescript
// Detected: UserService - 42 methods, 892 lines
// Severity: 🔴 High
// Recommendation: Split into UserAuth, UserProfile, UserSettings
```

### 7. Dead Code (Low Priority)

**Detection:**
- Unused functions/variables
- Commented-out code
- Unreachable code

**Why It's Bad:**
- Clutter
- Confusion
- Maintenance burden

**Fix:** Delete it (git preserves history)

**Example:**
```typescript
// Detected: function oldCalculation() - never called
// Severity: 🟢 Low
// Recommendation: Delete unused function
```

### 8. Complex Conditionals (High Priority)

**Detection:**
- Multiple conditions (> 3 combined)
- Nested ternaries
- Long boolean expressions

**Why It's Bad:**
- Hard to understand
- Easy to introduce bugs
- Testing difficulty

**Fix:** Extract to well-named functions, early returns

**Example:**
```typescript
// Detected: if with 5 conditions
// Severity: 🔴 High
// Recommendation: Extract isEligibleForDiscount() function
```

## Severity Classification

**🔴 Critical (Fix Now):**
- Security issues
- Performance bottlenecks
- System instability

**🔴 High (Fix Soon):**
- Long functions (> 50 lines)
- Deep nesting (> 3 levels)
- Major duplication
- God objects

**🟡 Medium (Fix When Refactoring):**
- Magic numbers
- Poor naming
- Moderate duplication
- Complex conditionals

**🟢 Low (Nice to Have):**
- Formatting inconsistencies
- Minor naming improvements
- Dead code
- Comment quality

## Detection Algorithms

### Long Function Detection

```typescript
function detectLongFunction(code: string): CodeSmell | null {
  const lines = code.split('\n').length;

  if (lines > 100) {
    return {
      smell: 'Long Function',
      severity: 'Critical',
      lines,
      recommendation: 'Extract 5+ functions'
    };
  }

  if (lines > 50) {
    return {
      smell: 'Long Function',
      severity: 'High',
      lines,
      recommendation: 'Extract 3-4 functions'
    };
  }

  return null;
}
```

### Nesting Depth Detection

```typescript
function detectDeepNesting(code: string): CodeSmell | null {
  const maxDepth = calculateMaxNestingDepth(code);

  if (maxDepth > 4) {
    return {
      smell: 'Deep Nesting',
      severity: 'High',
      depth: maxDepth,
      recommendation: 'Use early returns and extract functions'
    };
  }

  if (maxDepth > 3) {
    return {
      smell: 'Deep Nesting',
      severity: 'Medium',
      depth: maxDepth,
      recommendation: 'Simplify with early returns'
    };
  }

  return null;
}
```

### Duplication Detection

Use Grep to find similar code patterns:

```bash
# Find duplicate function signatures
Grep: pattern="function calculateTotal" output_mode="files_with_matches"

# Find similar code blocks
# Compare files for identical lines
```

### Magic Number Detection

```typescript
function detectMagicNumbers(code: string): CodeSmell[] {
  const smells = [];
  const numberPattern = /(?:^|[^\w\d])(\d+(?:\.\d+)?)(?:[^\w\d]|$)/g;
  const matches = code.matchAll(numberPattern);

  for (const match of matches) {
    const num = match[1];
    // Skip common constants (0, 1, -1, 100, etc.)
    if (!['0', '1', '-1', '100'].includes(num)) {
      smells.push({
        smell: 'Magic Number',
        severity: 'Medium',
        value: num,
        recommendation: `Extract constant for ${num}`
      });
    }
  }

  return smells;
}
```

## Analysis Process

### Step 1: Scan File

```
1. Read target file(s)
2. Run getDiagnostics for obvious issues
3. Analyze code structure
4. Detect each smell type
5. Classify by severity
```

### Step 2: Prioritize Issues

```
Sort by:
1. Severity (Critical → High → Medium → Low)
2. Impact (files affected, lines of code)
3. Effort (easy wins first)
```

### Step 3: Generate Report

```
For each smell:
- What: Specific issue
- Where: File and line number
- Why: Explanation of problem
- How: Recommended fix
- Effort: Estimated time
```

## Output Format

```
🔍 Code Quality Analysis

📁 Files Analyzed: X
📊 Issues Found: Y

🔴 Critical Issues (Z):
   None found ✅

🔴 High Priority (A):
   - Long Function: processOrder() - 87 lines
     Location: src/orders/process.ts:45
     Fix: Extract 4 functions
     Effort: 15 minutes

   - Deep Nesting: validateUser() - 5 levels
     Location: src/auth/validate.ts:120
     Fix: Use early returns
     Effort: 10 minutes

🟡 Medium Priority (B):
   - Magic Numbers: discount calculation - 3 occurrences
     Location: src/pricing/discount.ts:67-89
     Fix: Extract DISCOUNT_RATE, MIN_VALUE constants
     Effort: 5 minutes

   - Poor Naming: variable 'x', 'temp', 'data'
     Location: Multiple files
     Fix: Rename to descriptive names
     Effort: 5 minutes

🟢 Low Priority (C):
   - Dead Code: oldCalculation() - never called
     Location: src/utils/legacy.ts:234
     Fix: Delete unused function
     Effort: 1 minute

📈 Recommended Refactoring Order:
   1. validateUser() nesting (10 min, high impact)
   2. processOrder() extraction (15 min, high impact)
   3. Magic numbers (5 min, easy win)
   4. Poor naming (5 min, easy win)
   5. Dead code cleanup (1 min)

⏱️ Total Estimated Effort: 36 minutes
```

## Integration

Pass detected smells to refactoring-patterns skill for systematic fixes.

Coordinate with workflow-orchestrator for refactoring planning.

## Success Criteria

- ✅ Detect 95%+ of common code smells
- ✅ Accurate severity classification
- ✅ Actionable recommendations
- ✅ No false positives for standard patterns
- ✅ Clear prioritization
