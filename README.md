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

Output reports (`log.html`, `report.html`, `output.xml`) are written to the current directory by default. Use `-d results` to send them elsewhere:

```bash
robot -d results -t "Run Normal A02 P-Loan Base Scenario" tests/normal_base.robot
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
