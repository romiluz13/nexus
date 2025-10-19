# NEXUS v0.4.0 - Installation Test Guide

**Repository**: https://github.com/romiluz13/nexus
**Status**: ✅ Live on GitHub

---

## 🚀 Installation Instructions (For Testing)

### Step 1: Add Marketplace

```bash
/plugin marketplace add https://raw.githubusercontent.com/romiluz13/nexus/main/.claude-plugin/marketplace.json
```

**Expected Output**:
```
✅ Marketplace added: nexus
Found 4 plugins: feature-development, bug-fixing, code-quality, documentation
```

---

### Step 2: Restart Claude Code

```bash
# Exit Claude Code (Ctrl+C or Cmd+Q)
# Restart
claude
```

---

### Step 3: Install Plugins

```bash
# Install all 4 plugins
/plugin install feature-development@nexus
/plugin install bug-fixing@nexus
/plugin install code-quality@nexus
/plugin install documentation@nexus
```

**Expected Output**:
```
✅ Installed: feature-development@nexus
   Skills: complexity-analyzer, workflow-orchestrator, requirements-engineer
✅ Installed: bug-fixing@nexus
   Skills: debugging-methodology, root-cause-analyzer
✅ Installed: code-quality@nexus
   Skills: refactoring-patterns, code-smell-detector, test-coverage-improver
✅ Installed: documentation@nexus
   Skills: api-documentation, architecture-documentation, code-comments
```

---

### Step 4: Verify Installation

```bash
# List installed plugins
/plugin list

# Should see:
# - feature-development@nexus (3 skills)
# - bug-fixing@nexus (2 skills)
# - code-quality@nexus (3 skills)
# - documentation@nexus (3 skills)
```

---

## 🧪 Functional Tests

### Test 1: Orchestration Protocol

**Action**: Start any task
**Expected**: Claude should read CLAUDE.md automatically and follow orchestration protocol

**Test**:
```
User: "Build a simple REST API"
```

**Expected Claude Behavior**:
1. Checks orchestration protocol (mentions checking complexity)
2. Uses TodoWrite for planning (if complex enough)
3. Mentions checking if tasks can run in parallel
4. Follows decision tree logic

**Pass Criteria**: Claude mentions orchestration steps before implementing

---

### Test 2: Complexity Analysis

**Action**: Request a feature
**Expected**: complexity-analyzer skill activates

**Test**:
```
User: "Add user authentication with OAuth2"
```

**Expected Claude Behavior**:
1. Analyzes complexity using 5 dimensions
2. Provides score (0-10)
3. Recommends workflow (Direct/Blueprint/Epic)
4. Estimates time

**Pass Criteria**: Claude provides complexity breakdown with scores

---

### Test 3: Anti-Hallucination Validator

**Action**: Run the hallucination checker

**Test**:
```bash
# In your project
./scripts/hallucination-check.sh src/your-file.tsx
```

**Expected Output**:
```
🔍 NEXUS Anti-Hallucination Validator v1.0.0
Checking: src/your-file.tsx

📦 Checking imports/requires...
  ✅ react (exists in node_modules)
  ✅ ./components/Header (file exists)

📁 Checking relative file paths...
  ✅ ../utils/helpers.ts

✅ PASS: No hallucinations detected!
```

**Pass Criteria**: Script runs without errors, validates imports

---

### Test 4: Progressive Disclosure

**Action**: Load detailed reference

**Test**:
```
User: "I need detailed complexity scoring criteria"
```

**Expected Claude Behavior**:
1. Mentions loading references/scoring-guide.md
2. Provides detailed criteria
3. Does NOT load all references upfront (token efficient)

**Pass Criteria**: Claude loads references on-demand, not all at once

---

## 📊 Success Criteria

### Must Pass ✅

- [ ] Marketplace URL works (no 404)
- [ ] All 4 plugins install successfully
- [ ] All 11 skills are available
- [ ] CLAUDE.md loads automatically
- [ ] hallucination-check.sh is executable

### Should Pass ✅

- [ ] Orchestration protocol is followed
- [ ] Complexity analysis works correctly
- [ ] Progressive disclosure (references load on-demand)
- [ ] TodoWrite used for complex tasks

### Nice to Have ⭐

- [ ] Parallel execution demonstrated
- [ ] Adherence validated with validate-orchestration.py
- [ ] Hallucination checker catches fake imports

---

## 🐛 Common Issues

### Issue 1: Marketplace 404

**Problem**: `/plugin marketplace add` fails with 404
**Cause**: GitHub file not found
**Fix**: Verify URL is https://raw.githubusercontent.com/romiluz13/nexus/main/.claude-plugin/marketplace.json

### Issue 2: Plugins Not Found

**Problem**: Plugins don't appear after marketplace add
**Cause**: Didn't restart Claude Code
**Fix**: Exit and restart Claude Code

### Issue 3: Scripts Not Executable

**Problem**: hallucination-check.sh permission denied
**Cause**: Scripts lose execute bit on Windows
**Fix**: `chmod +x scripts/hallucination-check.sh`

### Issue 4: Skills Don't Activate

**Problem**: Skills don't seem to work
**Cause**: Claude hasn't read CLAUDE.md yet
**Fix**: Explicitly mention task type (e.g., "Build feature X" triggers complexity-analyzer)

---

## 📝 Test Report Template

```
# NEXUS v0.4.0 Test Report

**Tester**: [Your Name]
**Date**: [Date]
**Environment**: [OS, Claude Code version]

## Installation
- [ ] Marketplace added successfully
- [ ] All 4 plugins installed
- [ ] All 11 skills available

## Functionality
- [ ] Orchestration protocol followed
- [ ] Complexity analysis worked
- [ ] hallucination-check.sh executed
- [ ] Progressive disclosure observed

## Issues Found
[List any issues]

## Overall Assessment
[Pass / Fail / Needs Improvement]

## Comments
[Additional feedback]
```

---

## 🎯 Next Steps After Testing

### If Tests Pass ✅

1. **Create GitHub Release**:
   - Go to: https://github.com/romiluz13/nexus/releases/new
   - Tag: v0.4.0
   - Title: "NEXUS v0.4.0: Commanding Orchestration"
   - Description: Copy from CHANGELOG.md

2. **Announce**:
   - Share on Claude Code community
   - Post to relevant forums/Discord
   - Collect user feedback

3. **Monitor**:
   - Watch for GitHub issues
   - Respond to questions
   - Collect usage data

### If Tests Fail ❌

1. **Document Issues**:
   - Create GitHub issues for each problem
   - Include reproduction steps
   - Note expected vs actual behavior

2. **Fix & Retest**:
   - Address critical issues
   - Push fixes to main
   - Update tag if needed
   - Retest installation

3. **Iterate**:
   - v0.4.0-rc2 if major issues
   - v0.4.1 for minor fixes
   - v0.4.0 stable when ready

---

## 📞 Support

**Issues**: https://github.com/romiluz13/nexus/issues
**Questions**: Create issue with `question` label
**Bugs**: Create issue with `bug` label

---

**Happy Testing! 🚀**
