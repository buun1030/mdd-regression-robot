# Regression Test Automation

This project contains regression tests for the application, implemented using Robot Framework.

## Prerequisites

### 1. Create and activate a virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

Make sure `pip` and `python` actually point to the venv:

```bash
which pip      # should print .../venv/bin/pip
which python   # should print .../venv/bin/python
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Create `vars.yaml`

Copy the template and fill in your credentials. This file is gitignored.

```bash
cp vars.yaml.example vars.yaml
```

Then edit `vars.yaml` with the real values.

## Running the Tests

> **⚠️ VPN required for Mambu-related tests**
>
> Any test that talks to Mambu (e.g. `Run Normal A02 P-Loan Base Scenario`, `Run Normal A02 Nano-Loan Base Scenario`, and any other scenario that creates/queries loan accounts in Mambu) requires the company VPN to be connected before you run it. Without VPN the Mambu API calls will hang or fail with connection/timeout errors.
>
> Connect to VPN first, then run the tests.

You can run the tests in parallel using `pabot` or sequentially using `robot`.

### Keep each run's output separate (recommended)

By default Robot writes `log.html`, `report.html` and `output.xml` into the current directory, so every run overwrites the previous one. Use `--outputdir` to give each run its own folder under `results/` (already in `.gitignore`, so nothing there is committed):

```bash
robot --outputdir results/$(date +%Y%m%d-%H%M%S) -t "Run Normal A02 P-Loan Base Scenario" tests/normal_base.robot
```

Artifacts written by tests also go into that folder. For example `booking_upload_failure.robot` saves the Mambu loan document lists it compares:

```
results/<run>/
├── log.html  report.html  output.xml
├── loan_documents/
│   ├── <case_id>_1_after_auto_booking.json    # Step 14: right after automatic booking + taskpool auto retries (captured before any assertion)
│   └── <case_id>_2_after_manual_rebook.json   # Step 21: after fixing the broken document + manual rebook
└── evidence/
    ├── <case_id>_1_after_auto_booking.json    # system state before the fix (case status, fields, booking report)
    ├── <case_id>_2_after_manual_rebook.json   # system state after the manual rebook
    └── <case_id>_summary.md                   # before/after table — use this (or the same table in log.html) as the test result screenshot
```

`log.html` links to every file and shows the before/after table under Step 21.

Evidence values are read from the system at that moment (`get-case-detail` = `customer_data` in the DB, `get-booking-report-detail`, Mambu `documentsMetadata`), not from what the test intended to send. The DB keeps only the latest value of a field, so the "before" value (e.g. `_documents.5.name = evil.exe`) cannot be screenshotted from the DB after the run — use the evidence files instead. If you run without `--outputdir`, `loan_documents/` and `evidence/` are created at the repo root (also ignored).

Flags for `booking_upload_failure.robot`:

| flag | default | effect |
|---|---|---|
| `-v CHECK_UPLOAD_DEDUPE:False` | `True` | skip Step 19 (no duplicated loan documents after auto retries) |
| `-v CHECK_MANUAL_RETRY:False` | `True` | skip Step 20-21 (fix the broken document, manual rebook, expect exactly 1 new document) |

### Parallel Execution

Run all tests in parallel:

```bash
pabot --testlevelsplit tests
```

### Sequential Execution (Recommended)

Run all tests sequentially (useful for debugging):

```bash
robot tests
```

Run a single test file:

```bash
robot tests/normal_base.robot
```

Run a single test case by name (use the exact case name; `*` wildcards work):

```bash
robot -t "Run Normal A02 P-Loan Base Scenario" tests/normal_base.robot
```

Run multiple test cases matching a pattern:

```bash
robot -t "Run Normal A02*" tests/normal_base.robot
```

Run tests across the whole suite by name (no file path needed — Robot searches all `tests/`):

```bash
robot -t "Run Normal A02 P-Loan Base Scenario" tests
```

Run by tag (if your tests use tags):

```bash
robot -i <tag-name> tests
```

Output reports (`log.html`, `report.html`, `output.xml`) are written to the current directory by default. `-d` (= `--outputdir`) sends them elsewhere — a fixed folder like `-d results` is still overwritten on every run, so add a timestamp to keep each run (see [Keep each run's output separate](#keep-each-runs-output-separate-recommended)):

```bash
robot -d results/$(date +%Y%m%d-%H%M%S) -t "Run Normal A02 P-Loan Base Scenario" tests/normal_base.robot
```

## Troubleshooting

### `error: externally-managed-environment` when running `pip install`

This means `pip` is pointing to the system / Homebrew Python instead of the venv. Even if your prompt shows `(venv)`, run:

```bash
which pip
```

If the path is **not** under `venv/bin/`, one of these is the cause:

1. **The venv is broken** — delete and recreate it:

   ```bash
   deactivate 2>/dev/null
   rm -rf venv
   /opt/homebrew/bin/python3 -m venv venv
   source venv/bin/activate
   ```

2. **You have a shell alias overriding `python` / `pip`** — check with:

   ```bash
   type python
   type pip
   ```

   If you see `python: aliased to ...`, remove the alias for the current session:

   ```bash
   unalias python pip
   ```

   To make it permanent, add this to the end of `~/.zshrc`:

   ```bash
   unalias python 2>/dev/null
   unalias pip 2>/dev/null
   ```

3. **As a last resort**, bypass `activate` entirely and call the venv's `pip` directly:

   ```bash
   ./venv/bin/pip install -r requirements.txt
   ./venv/bin/robot tests
   ```

### Project path contains spaces

Some Python tooling misbehaves on paths like `~/Desktop/Thinker Workspace/...`. If you hit weird import or path errors, move the project to a space-free path (e.g. `~/workspace/regression_robot`).
