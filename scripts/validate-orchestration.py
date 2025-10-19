#!/usr/bin/env python3
"""
NEXUS Orchestration Validation Script

Analyzes Claude's chat history to check if orchestration guidelines were followed.

Usage:
    python scripts/validate-orchestration.py

Output:
    - Adherence score (0-100%)
    - Violations list
    - Grade (A/B/C/D/F)
    - Recommendations for improvement
"""

import re
from pathlib import Path
from typing import Dict, List, Tuple

def analyze_orchestration(history: str) -> Dict:
    """
    Analyze chat history for orchestration compliance

    Checks:
    1. Was CLAUDE.md orchestration protocol read early?
    2. Was TodoWrite used for complex tasks?
    3. Were parallel agents used when applicable?
    4. Were decision trees followed?

    Returns: {adherence_score, violations, grade, recommendations}
    """

    score = 0
    max_score = 100
    violations = []
    recommendations = []

    # Check 1: Orchestration Protocol Read Early (25 points)
    # Look for CLAUDE.md or orchestration keywords in first 5000 chars
    early_history = history[:5000]

    orchestration_indicators = [
        "CLAUDE.md",
        "orchestration protocol",
        "Should I use sub-agents",
        "Can I run tasks in parallel",
        "complexity assessment"
    ]

    protocol_read = any(indicator.lower() in early_history.lower()
                       for indicator in orchestration_indicators)

    if protocol_read:
        score += 25
    else:
        violations.append("Orchestration protocol not checked early")
        recommendations.append("Read CLAUDE.md orchestration protocol before starting work")

    # Check 2: TodoWrite for Complex Tasks (25 points)
    # Look for complexity indicators + TodoWrite usage

    complexity_indicators = [
        "build", "implement", "create", "design", "refactor",
        "multiple", "several", "complex", "feature"
    ]

    has_complex_task = any(word in history.lower()
                          for word in complexity_indicators)

    todowrite_used = "TodoWrite" in history or "todo" in history.lower()

    if has_complex_task:
        if todowrite_used:
            score += 25
        else:
            violations.append("Complex task detected but TodoWrite not used for planning")
            recommendations.append("Use TodoWrite to plan complex tasks before implementing")
    else:
        # Simple task, TodoWrite not required
        score += 25

    # Check 3: Parallel Execution (25 points)
    # Look for parallel indicators vs sequential execution

    parallel_indicators = [
        "in parallel", "parallel", "simultaneously",
        "multiple tool calls", "single message"
    ]

    task_tool_count = history.count("<invoke name=\"Task")
    edit_tool_count = history.count("<invoke name=\"Edit")
    write_tool_count = history.count("<invoke name=\"Write")

    total_potential_parallel = task_tool_count + edit_tool_count + write_tool_count

    parallel_used = any(phrase in history.lower()
                       for phrase in parallel_indicators)

    if total_potential_parallel > 1:
        # Multiple tools used - check if parallel
        if parallel_used:
            score += 25
        else:
            # Check if tools were called in same message (proper parallel)
            # This is a simplification - real check would parse XML structure
            violations.append("Multiple independent tasks executed sequentially")
            recommendations.append("Launch parallel agents in single message with multiple tool calls")
    else:
        # Single task or already parallel
        score += 25

    # Check 4: Decision Tree Followed (25 points)
    # Look for evidence of strategic decision-making

    decision_indicators = [
        "checking complexity",
        "decision tree",
        "simple or complex",
        "assess",
        "medium or complex",
        "identify sub-tasks"
    ]

    decision_followed = any(phrase in history.lower()
                           for phrase in decision_indicators)

    if decision_followed:
        score += 25
    else:
        violations.append("No evidence of decision tree evaluation")
        recommendations.append("Follow complexity assessment decision tree before implementing")

    # Calculate grade
    grade = get_grade(score)

    return {
        "adherence_score": score,
        "max_score": max_score,
        "violations": violations,
        "recommendations": recommendations,
        "grade": grade,
        "details": {
            "protocol_read": protocol_read,
            "planning_used": todowrite_used if has_complex_task else "N/A (simple task)",
            "parallel_execution": parallel_used if total_potential_parallel > 1 else "N/A (single task)",
            "decision_tree": decision_followed
        }
    }

def get_grade(score: int) -> Tuple[str, str]:
    """Convert score to letter grade with description"""
    if score >= 90:
        return ("A", "Excellent orchestration - Following all guidelines")
    elif score >= 75:
        return ("B", "Good orchestration - Minor improvements needed")
    elif score >= 60:
        return ("C", "Fair orchestration - Several improvements needed")
    elif score >= 40:
        return ("D", "Poor orchestration - Major improvements needed")
    else:
        return ("F", "Orchestration ignored - Violating core principles")

def format_report(results: Dict) -> str:
    """Format validation results as readable report"""

    grade_letter, grade_desc = results["grade"]

    report = f"""
╔════════════════════════════════════════════════════════════════╗
║             NEXUS ORCHESTRATION VALIDATION REPORT              ║
╚════════════════════════════════════════════════════════════════╝

📊 ADHERENCE SCORE: {results["adherence_score"]}/{results["max_score"]} ({results["adherence_score"]}%)

🎓 GRADE: {grade_letter} - {grade_desc}

"""

    if results["violations"]:
        report += "❌ VIOLATIONS:\n"
        for i, violation in enumerate(results["violations"], 1):
            report += f"   {i}. {violation}\n"
        report += "\n"
    else:
        report += "✅ NO VIOLATIONS - Perfect orchestration!\n\n"

    if results["recommendations"]:
        report += "💡 RECOMMENDATIONS:\n"
        for i, rec in enumerate(results["recommendations"], 1):
            report += f"   {i}. {rec}\n"
        report += "\n"

    report += "📋 DETAILS:\n"
    for key, value in results["details"].items():
        status = "✅" if value not in [False, "N/A (simple task)", "N/A (single task)"] else "❌"
        report += f"   {status} {key.replace('_', ' ').title()}: {value}\n"

    report += "\n"
    report += "=" * 66

    return report

def main():
    """Main validation entry point"""

    # For demo purposes, this would normally read from a chat history file
    # or integrate with Claude Code's history API

    print("NEXUS Orchestration Validator")
    print("=" * 66)
    print()
    print("This script validates if Claude followed orchestration guidelines.")
    print("In production, it would analyze chat history from Claude Code.")
    print()
    print("Example validation (demo mode):")
    print()

    # Demo: Good orchestration example
    demo_good_history = """
    <invoke name="Read">
      <parameter name="file_path">/path/to/CLAUDE.md    Checking orchestration protocol...
    Using TodoWrite for planning...
    Launching tasks in parallel...
    """

    results_good = analyze_orchestration(demo_good_history)
    print(format_report(results_good))

    print("\n\n")
    print("Example with violations (demo mode):")
    print()

    # Demo: Poor orchestration example
    demo_poor_history = """
    User: Build authentication system
    Claude: Let me implement the backend first...
    [implements sequentially without planning]
    """

    results_poor = analyze_orchestration(demo_poor_history)
    print(format_report(results_poor))

    print("\n")
    print("💡 To use with real chat history:")
    print("   python scripts/validate-orchestration.py <path-to-history.txt>")

if __name__ == "__main__":
    main()
