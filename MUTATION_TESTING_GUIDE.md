# 🧬 Mutation Testing Matrix - Complete Guide

## Overview

This is a **professional-grade mutation testing workflow** using GitHub Actions matrix strategy to systematically analyze test effectiveness across multiple modules.

## What This Workflow Does

### 1. **Matrix Strategy**
```yaml
strategy:
  matrix:
    include:
      - module_path: frigate/util/path.py
        module_name: Path Utils (Security)
        test_file: frigate/test/test_util_path.py
        priority: critical
```

- Tests **multiple modules in parallel** (not separate workflow files!)
- Each module gets its own isolated analysis
- Easy to add/remove modules by editing one file
- Results aggregated in summary job

### 2. **Comprehensive Test Cycle**

#### Phase 1: Baseline Testing
- Runs pytest on the test file first
- Captures: tests found, passed, failed
- **Purpose:** Verify tests are working before mutation

#### Phase 2: Mutation Generation & Testing
- Mutmut generates mutations in the module code
- Runs tests against each mutation
- Tracks which mutations are caught (killed) vs missed (survived)

#### Phase 3: Detailed Analysis
- Extracts metrics: total, killed, survived, timeouts, errors
- Calculates mutation score (% of mutations caught)
- Generates HTML visual report

#### Phase 4: Enforcement
- **Fails workflow if mutation score < 70%**
- This prevents regression of test quality
- Enforces continuous improvement

## Key Metrics Explained

| Metric | Meaning | What It Tells You |
|--------|---------|-------------------|
| **Total** | Mutations generated | How many code variations were tested |
| **Killed** | Mutations caught by tests | How many defects your tests would catch |
| **Survived** | Mutations NOT caught | Test gaps - what your tests miss |
| **Timeouts** | Mutations causing infinite loops | Edge cases that break the code |
| **Errors** | Mutations causing crashes | Unhandled edge cases |
| **Score** | (Killed / Total) × 100 | Overall test effectiveness (%) |

## Workflow Features

### ✅ What Makes This Professional

1. **Matrix Strategy** (Not 70 separate files!)
   - One workflow handles all modules
   - Scalable design
   - Easy maintenance

2. **Comprehensive Metrics**
   - Not just "killed vs survived"
   - Captures timeouts, errors, skipped
   - Better diagnostics

3. **Detailed Reports**
   - HTML visual report
   - GitHub Step Summary for PRs
   - Artifact uploads for deep dive

4. **Enforcement**
   - Fails if mutation score drops
   - Prevents test quality regression
   - Clear threshold (70%)

5. **Baseline Testing**
   - Tests run successfully first
   - Mutation testing only runs after verification
   - Catches broken tests early

## Running the Workflow

### Option 1: Manual Trigger (Recommended for Testing)
```bash
# GitHub UI: Actions > Mutation Testing - Matrix Analysis > Run workflow
# Or: gh workflow run mutation-testing-matrix.yml -f modules=all
```

### Option 2: On Push (CI Mode)
- Automatically runs when you push to `main`
- Only if files in `frigate/util/**` or tests changed

### Option 3: On Pull Request
- Runs on every PR to `main`
- Adds detailed comment with results

## Understanding the Results

### Scenario 1: Excellent Score (80%+)
```
✅ Mutation Score: 85%
   Total: 100 mutations
   Killed: 85 (tests caught these)
   Survived: 15 (test gaps)

Action: ✅ No action needed - tests are strong
```

### Scenario 2: Good Score (70-79%)
```
🟡 Mutation Score: 75%
   Total: 100 mutations
   Killed: 75
   Survived: 25

Action: Review survived mutations, improve tests
```

### Scenario 3: Poor Score (<70%)
```
❌ Mutation Score: 55%
   Total: 100 mutations
   Killed: 55
   Survived: 45

Action: 🛑 WORKFLOW FAILS - Must improve tests
```

## Reading Survived Mutations

When mutations **survive**, it means:
- The mutation changed the code
- Tests still passed
- **Your tests are too weak**

Example:
```python
# Original code
if x > 10:
    return True

# Survived mutation
if x >= 10:  # Changed > to >=
    return True

# Problem: Your test never checked boundary at x=10
# Fix: Add test case: x=10 should trigger specific behavior
```

## Adding More Modules

### Step 1: Create Test File
```python
# frigate/test/test_new_module.py
class TestNewModule(unittest.TestCase):
    def test_something(self):
        ...
```

### Step 2: Update Workflow Matrix
```yaml
matrix:
  include:
    # ... existing modules ...
    
    - module_path: frigate/new_module.py
      module_name: New Module
      test_file: frigate/test/test_new_module.py
      priority: high
```

### Step 3: Run Workflow
```bash
git push  # Triggers automatically
```

## Interpreting Survived Mutations

### High-Priority Issues
```
❌ SURVIVED: change < to <=
   File: frigate/util/path.py:34
   Impact: Security boundary condition
   Fix: Add test with boundary value
```

### Low-Priority Issues
```
⚠️ SURVIVED: change variable name
   File: frigate/util/builtin.py:120
   Impact: Docstring, no functional change
   Fix: Exclude from mutation testing
```

## Performance Notes

- **~30 seconds per module** (adjustable via `timeout-minutes`)
- **Parallel execution** by GitHub Actions
- **Cached** pytest/pip installations
- Total time: ~1-2 min for all modules

## Troubleshooting

### Workflow Not Triggering
```bash
# Check file paths in trigger condition
# Make sure you pushed to main or opened PR to main
git log --oneline -5  # Verify commit
```

### Mutation Score Failing Unexpectedly
```bash
# Run locally to debug
mutmut run --paths frigate/util/path.py --tests-dir frigate/test
```

### Reports Not Generated
```bash
# Check artifacts after workflow runs
# GitHub UI > Actions > Run > Artifacts section
```

## Next: Run Locally First

Before pushing to GitHub, test locally:

```bash
# Install dependencies
pip install mutmut pytest pytest-mock coverage

# Run on test_util_path.py (our first target)
mutmut run \
  --paths frigate/util/path.py \
  --tests-dir frigate/test \
  --no-progress

# View results
mutmut results
```

## Key Takeaways

✅ **This workflow:**
- Tests multiple modules efficiently
- Provides comprehensive metrics
- Enforces quality standards
- Scales easily
- Professional-grade approach

❌ **Not:**
- 70 separate workflow files
- Just counting killed/survived
- Manual effort
- Difficult to maintain

---

## Next Action: Run on `test_util_path.py`

Ready to run mutation testing on path utilities?

```bash
# See actual mutation test results in next section
```
