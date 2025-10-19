# Contributing to NEXUS

Thank you for your interest in contributing to NEXUS! This document provides guidelines for contributing to the state-of-the-art Skills-First Claude Code plugin architecture.

## 🎯 Philosophy

NEXUS pioneered the **Skills-First Architecture** where Agent Skills are the primary orchestration engine. All contributions should align with these core principles:

1. **Skills Over Commands** - Add capabilities through skills, not slash commands
2. **Granular Over Monolithic** - Create focused skills (50-200 lines) with single responsibility
3. **Progressive Disclosure** - Use 3-tier structure (metadata → skill → references)
4. **Zero Duplication** - No overlapping functionality between skills
5. **Harmonious Orchestration** - Skills must integrate smoothly without conflicts

## 🚀 Quick Start

### Setup
```bash
# Clone the repository
git clone https://github.com/your-org/nexus.git
cd nexus

# Install dependencies (currently zero external deps)
npm install

# Run tests
npm test

# Verify TypeScript
npm run typecheck
```

### Project Structure
```
nexus/
├── .claude-plugin/plugins/
│   ├── feature-development/     # 3 skills
│   ├── bug-fixing/              # 2 skills
│   ├── code-quality/            # 3 skills
│   └── documentation/           # 3 skills
├── CLAUDE.md                    # Development guide (100 lines max)
├── README.md                    # User documentation
└── SYNTHESIS.md                 # Pattern analysis
```

## 📝 How to Contribute

### 1. Adding a New Skill

**Before you start:**
- Check if functionality already exists
- Ensure no overlap with existing skills
- Verify it fits within a plugin's scope

**Skill Requirements:**
- 50-200 lines (ideal: ~150 lines)
- Clear single responsibility
- Imperative writing style ("Do X" not "You should do X")
- Proper YAML frontmatter
- Standard section structure

**Standard Skill Template:**
```markdown
---
name: [skill-name]
description: |
  [What it does, when to activate, clear triggers]
allowed-tools: [Tool1, Tool2, Tool3]
---

# [Skill Name]

## Purpose
[Single paragraph explaining purpose]

## When to Activate
**Trigger Keywords:**
- "keyword1", "keyword2"

**Examples:**
- "User says this"
- "User says that"

## [Core Method Section]
[Main methodology/process]

## Output Format
[How skill presents results]

## Edge Cases
[Unusual situations to handle]

## Integration
[How this skill coordinates with others]

## Success Criteria
- ✅ [Measurable success criterion 1]
- ✅ [Measurable success criterion 2]
```

**Steps to Add:**
1. Create skill directory in appropriate plugin
2. Add SKILL.md following template
3. Update plugin.json with skill name
4. Add skill to README.md table
5. Document integration points
6. Test activation with various phrases

### 2. Creating a New Plugin

**When to create a new plugin:**
- New domain not covered by existing 4 plugins
- Contains 2-5 related skills
- Clear boundary from existing plugins

**Plugin Requirements:**
- Focused domain (single responsibility at plugin level)
- 2-5 skills minimum
- Clear integration with other plugins
- plugin.json manifest

**Steps:**
1. Create plugin directory structure
2. Add .claude-plugin/plugin.json
3. Create 2-5 initial skills
4. Update README with new plugin section
5. Document orchestration with existing plugins

### 3. Improving Documentation

**Documentation priorities:**
- Keep CLAUDE.md under 110 lines (project facts only)
- README for users, CLAUDE.md for developers
- Examples should be realistic, not placeholder data
- Update CHANGELOG.md for all changes

### 4. Fixing Bugs

**Bug fix process:**
1. Reproduce the issue
2. Add test demonstrating the bug
3. Fix the issue
4. Verify test passes
5. Check no new issues introduced

## ✅ Pull Request Guidelines

### Before Submitting

**Checklist:**
- [ ] Code follows project conventions (see CLAUDE.md)
- [ ] TypeScript compiles (`npm run typecheck`)
- [ ] All tests pass (`npm test`)
- [ ] No duplication with existing functionality
- [ ] Integration points documented
- [ ] README updated if needed
- [ ] CHANGELOG.md updated

### PR Title Format
```
[type]: Brief description

Types:
- feat: New skill or plugin
- fix: Bug fix
- docs: Documentation only
- refactor: Code restructuring
- test: Adding tests
- chore: Maintenance
```

### PR Description Template
```markdown
## What
[Brief description of changes]

## Why
[Motivation and context]

## How
[Technical approach]

## Testing
[How to test these changes]

## Integration
[How this affects other skills/plugins]

## Checklist
- [ ] TypeScript compiles
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No conflicts/duplication
```

## 🎨 Code Conventions

### TypeScript
- **Strict mode**: Always enabled
- **Naming**: kebab-case files, camelCase functions, PascalCase interfaces
- **Max file size**: 300 lines (refactor if larger)
- **No `any` type**: Use `unknown` or specific types

### Skills
- **Size**: 50-200 lines (average ~150)
- **Writing**: Imperative form, no "you/your"
- **Structure**: Follow standard template
- **Integration**: Always include Integration section

### Documentation
- **CLAUDE.md**: Facts only, no orchestration logic
- **Skills**: Concise, clear triggers
- **Examples**: Realistic data, complete workflows

## 🔍 Code Review Process

**What reviewers look for:**
1. **No duplication**: Skill doesn't overlap with existing
2. **Proper integration**: Coordinates smoothly with others
3. **Size**: Within 50-200 line target
4. **Quality**: Clear, concise, well-structured
5. **Testing**: Adequate test coverage
6. **Documentation**: Integration points documented

## 📚 Resources

- **CLAUDE.md**: Development guide
- **README.md**: User documentation
- **SYNTHESIS.md**: Architecture patterns analysis
- **Skills**: `/claude-plugin/plugins/*/skills/*/SKILL.md`

## 🤝 Community

### Getting Help
- Open an issue for questions
- Check existing skills for patterns
- Review SYNTHESIS.md for best practices

### Discussions
- Feature requests: GitHub Issues
- Architecture discussions: GitHub Discussions
- Quick questions: Issue comments

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be added to a CONTRIBUTORS.md file. Significant contributions may be recognized in release notes.

---

**Thank you for helping make NEXUS the definitive Claude Code plugin architecture!** ✨
