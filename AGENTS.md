# Repository Guidelines

## Project Structure & Module Organization
Regression suites live in `tests/`, each combining scenario data with shared keywords to drive end-to-end flows (tests/normal_base.robot:1). Shared API-driving keywords and retriable checks are implemented under `resources/thinker_keywords.robot` and `resources/retry_keywords.robot` (resources/thinker_keywords.robot:1; resources/retry_keywords.robot:1). Scenario payloads and constants are defined in `scenarios.py`, while reusable credentials sit in `vars.yaml`; generated artifacts are written to `results/` after a run (vars.yaml:1; results/log.html). Keep new suites colocated with shared resources to preserve this separation.

## Build, Test, and Development Commands
- `source venv/bin/activate` — activate the maintained virtualenv before running anything (README.md:17).
- `pip install -r requirements.txt` — sync Robot Framework dependencies (requirements.txt:1).
- `pabot --testlevelsplit tests` — execute suites in parallel; default command used in CI (README.md:29).
- `robot tests` — sequential execution for debugging or when isolating flaky cases (README.md:37).
Preserve the virtualenv to avoid leaking system packages; add new libraries to `requirements.txt`.

## Coding Style & Naming Conventions
Robot suites use four-space alignment with one token per column; keep spacing consistent with existing files (tests/gsb_lead_base.robot:1). Name suites in Title Case describing the journey, while keywords remain verb-first phrases such as `Normal Workflow` and `Create Thinker Session` (tests/normal_base.robot:16; resources/thinker_keywords.robot:10). Use uppercase scalar names with `${}` for shared data, and prefer dictionaries/lists for structured payloads.

## Testing Guidelines
Introduce new scenarios in `scenarios.py` and drive them through suite keywords so they inherit shared logging and verification steps (tests/normal_base.robot:18). Assertions rely on Robot’s `Should` family; keep failure messages business-specific. Run `pabot` locally before opening a PR and attach the resulting `log.html` or `report.html` when reporting failures (results/log.html).

## Commit & Pull Request Guidelines
This workspace snapshot lacks `.git`, so adopt a clear format: `<scope>: <imperative summary>` (for example, `tests: add nano-loan regression`). Reference related tickets in the body, call out data or credential impacts, and note whether parallel and sequential runs succeeded.

## Security & Configuration Tips
Treat `vars.yaml` credentials and the `BASE_URL` constant as environment-specific; never commit production secrets (vars.yaml:1; resources/thinker_keywords.robot:7). Prefer overriding sensitive values via CI secrets or local environment variables instead of hardcoding.
