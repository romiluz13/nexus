#!/usr/bin/env bash
set -euo pipefail

# NEXUS Anti-Hallucination Validator
# Validates that AI-generated code doesn't reference non-existent imports, files, or APIs
#
# Usage: ./scripts/hallucination-check.sh <file-path>
# Example: ./scripts/hallucination-check.sh src/components/UserProfile.tsx

VERSION="1.0.0"
FILE="$1"
ERRORS=0
WARNINGS=0

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 NEXUS Anti-Hallucination Validator v${VERSION}${NC}"
echo -e "${BLUE}Checking: ${FILE}${NC}\n"

# Get file extension
EXT="${FILE##*.}"

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo -e "${RED}❌ ERROR: File does not exist: ${FILE}${NC}"
  exit 1
fi

# ============================================================================
# CHECK 1: Import/Require Validation (JavaScript/TypeScript)
# ============================================================================
check_imports_js_ts() {
  echo -e "${BLUE}📦 Checking imports/requires...${NC}"

  # Extract import statements
  IMPORTS=$(grep -E "^import .* from ['\"]" "$FILE" | sed -E "s/.*from ['\"]([^'\"]+)['\"].*/\1/" || true)
  REQUIRES=$(grep -E "require\(['\"]" "$FILE" | sed -E "s/.*require\(['\"]([^'\"]+)['\"].*/\1/" || true)

  ALL_DEPS="$IMPORTS"$'\n'"$REQUIRES"

  for dep in $ALL_DEPS; do
    if [ -z "$dep" ]; then continue; fi

    # Skip relative imports for now (check separately)
    if [[ "$dep" == ./* ]] || [[ "$dep" == ../* ]]; then
      continue
    fi

    # Check if it's a known package (exists in node_modules or is built-in)
    if [ -d "node_modules/$dep" ] || [ -d "node_modules/${dep%%/*}" ]; then
      echo -e "  ${GREEN}✓${NC} $dep (exists in node_modules)"
    else
      # Check if it's a built-in Node.js module
      case "$dep" in
        fs|path|http|https|crypto|util|stream|events|buffer|process|os|url|querystring|assert|child_process|cluster|dgram|dns|net|readline|repl|tls|tty|vm|zlib)
          echo -e "  ${GREEN}✓${NC} $dep (Node.js built-in)"
          ;;
        react|react-dom|react-native)
          # Check if React is in package.json
          if grep -q "\"$dep\"" package.json 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $dep (in package.json)"
          else
            echo -e "  ${YELLOW}⚠️  WARNING${NC}: $dep not found in node_modules or package.json"
            ((WARNINGS++))
          fi
          ;;
        *)
          echo -e "  ${YELLOW}⚠️  WARNING${NC}: $dep not found in node_modules (might be aliased or external)"
          ((WARNINGS++))
          ;;
      esac
    fi
  done
}

# ============================================================================
# CHECK 2: Relative Path Validation
# ============================================================================
check_relative_paths() {
  echo -e "\n${BLUE}📁 Checking relative file paths...${NC}"

  # Get directory of the file being checked
  DIR=$(dirname "$FILE")

  # Extract relative imports
  REL_IMPORTS=$(grep -E "from ['\"]\.\.?/" "$FILE" | sed -E "s/.*from ['\"]([^'\"]+)['\"].*/\1/" || true)
  REL_REQUIRES=$(grep -E "require\(['\"]\.\.?/" "$FILE" | sed -E "s/.*require\(['\"]([^'\"]+)['\"].*/\1/" || true)

  ALL_REL="$REL_IMPORTS"$'\n'"$REL_REQUIRES"

  for rel_path in $ALL_REL; do
    if [ -z "$rel_path" ]; then continue; fi

    # Resolve the path
    FULL_PATH="$DIR/$rel_path"

    # Try with various extensions
    FOUND=false
    for ext in "" ".ts" ".tsx" ".js" ".jsx" ".json" ".mjs"; do
      if [ -f "${FULL_PATH}${ext}" ]; then
        echo -e "  ${GREEN}✓${NC} $rel_path${ext}"
        FOUND=true
        break
      fi
    done

    # Check if it's a directory with index file
    if [ "$FOUND" = false ]; then
      for ext in ".ts" ".tsx" ".js" ".jsx"; do
        if [ -f "${FULL_PATH}/index${ext}" ]; then
          echo -e "  ${GREEN}✓${NC} $rel_path/index${ext}"
          FOUND=true
          break
        fi
      done
    fi

    if [ "$FOUND" = false ]; then
      echo -e "  ${RED}❌ ERROR${NC}: File not found: $rel_path (checked .ts, .tsx, .js, .jsx, .json, index.*)"
      ((ERRORS++))
    fi
  done
}

# ============================================================================
# CHECK 3: Python Import Validation
# ============================================================================
check_imports_python() {
  echo -e "${BLUE}📦 Checking Python imports...${NC}"

  # Extract import statements
  IMPORTS=$(grep -E "^import |^from .* import" "$FILE" || true)

  while IFS= read -r line; do
    if [ -z "$line" ]; then continue; fi

    # Extract module name
    if [[ "$line" =~ ^import[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*) ]]; then
      MODULE="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^from[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*) ]]; then
      MODULE="${BASH_REMATCH[1]}"
    else
      continue
    fi

    # Check if it's a relative import
    if [[ "$line" =~ ^from[[:space:]]+\. ]]; then
      echo -e "  ${BLUE}→${NC} $MODULE (relative import, skipping)"
      continue
    fi

    # Check if it's a standard library module
    case "$MODULE" in
      os|sys|json|re|time|datetime|math|random|collections|itertools|functools|pathlib|typing|abc|enum)
        echo -e "  ${GREEN}✓${NC} $MODULE (Python standard library)"
        ;;
      *)
        # Check if module exists (try to import it)
        if python3 -c "import $MODULE" 2>/dev/null; then
          echo -e "  ${GREEN}✓${NC} $MODULE (installed)"
        else
          echo -e "  ${YELLOW}⚠️  WARNING${NC}: $MODULE not found (might need installation)"
          ((WARNINGS++))
        fi
        ;;
    esac
  done <<< "$IMPORTS"
}

# ============================================================================
# CHECK 4: Common API Hallucinations
# ============================================================================
check_common_apis() {
  echo -e "\n${BLUE}🔌 Checking for common API hallucinations...${NC}"

  # React hooks hallucinations
  if [[ "$FILE" == *.tsx ]] || [[ "$FILE" == *.jsx ]]; then
    # Check for non-existent React hooks
    FAKE_HOOKS="useMagic|useAutomatic|usePerfect|useAdvanced|useOptimized|useEnhanced|usePowerful"
    if grep -qE "use[A-Z][a-zA-Z]*" "$FILE"; then
      FOUND_HOOKS=$(grep -oE "use[A-Z][a-zA-Z]*" "$FILE" | sort -u)
      VALID_HOOKS="useState|useEffect|useContext|useReducer|useCallback|useMemo|useRef|useImperativeHandle|useLayoutEffect|useDebugValue|useDeferredValue|useTransition|useId|useSyncExternalStore"

      for hook in $FOUND_HOOKS; do
        if ! echo "$VALID_HOOKS" | grep -qw "$hook"; then
          echo -e "  ${YELLOW}⚠️  WARNING${NC}: Uncommon React hook detected: $hook (verify this exists)"
          ((WARNINGS++))
        fi
      done
    fi
  fi

  # Check for made-up config keys
  if [[ "$FILE" == *.json ]]; then
    # Common config hallucinations
    if grep -qE "(magicalOptimization|superFast|autoFix|perfectMode)" "$FILE"; then
      echo -e "  ${RED}❌ ERROR${NC}: Suspicious config keys detected (likely hallucination)"
      ((ERRORS++))
    fi
  fi
}

# ============================================================================
# CHECK 5: Validate Against Codebase Patterns
# ============================================================================
check_codebase_patterns() {
  echo -e "\n${BLUE}🎯 Checking against existing codebase patterns...${NC}"

  # Check if file uses patterns consistent with codebase
  if [[ "$FILE" == *.ts ]] || [[ "$FILE" == *.tsx ]]; then
    # Check for consistent export patterns
    if grep -q "^export default" "$FILE"; then
      echo -e "  ${GREEN}✓${NC} Uses default export (matches codebase)"
    elif grep -q "^export " "$FILE"; then
      echo -e "  ${GREEN}✓${NC} Uses named exports (matches codebase)"
    fi

    # Check for TypeScript strict mode compliance
    if grep -qE ": any[^a-zA-Z]|as any" "$FILE"; then
      echo -e "  ${YELLOW}⚠️  WARNING${NC}: Found 'any' type (TypeScript strict mode violation)"
      ((WARNINGS++))
    fi
  fi
}

# ============================================================================
# Main Execution
# ============================================================================

case "$EXT" in
  ts|tsx|js|jsx|mjs)
    check_imports_js_ts
    check_relative_paths
    check_common_apis
    check_codebase_patterns
    ;;
  py)
    check_imports_python
    check_common_apis
    ;;
  *)
    echo -e "${YELLOW}⚠️  File type not supported for validation: $EXT${NC}"
    exit 0
    ;;
esac

# ============================================================================
# Summary Report
# ============================================================================
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 VALIDATION SUMMARY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✅ PASS${NC}: No hallucinations detected!"
  echo -e "File: ${FILE}"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠️  PASS with warnings${NC}"
  echo -e "Errors: ${ERRORS}"
  echo -e "Warnings: ${WARNINGS}"
  echo -e "\nWarnings indicate potential issues but don't block validation."
  exit 0
else
  echo -e "${RED}❌ FAIL${NC}: Hallucinations detected!"
  echo -e "Errors: ${ERRORS}"
  echo -e "Warnings: ${WARNINGS}"
  echo -e "\nPlease fix the errors above before committing."
  exit 1
fi
