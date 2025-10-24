# Regression Test Automation

This project contains regression tests for the application, implemented using Robot Framework.

## Prerequisites

Before running the tests, activate the virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

Before running the tests, make sure you have Python and pip installed. Then, install the project dependencies:

```bash
pip install -r requirements.txt
```

## Running the Tests

You can run the tests in parallel using `pabot` or sequentially using `robot`.

### Parallel Execution (Recommended)

To run the tests in parallel, use the following command:

```bash
pabot --testlevelsplit tests
```

### Sequential Execution

To run the tests sequentially, which can be useful for debugging, use the following command:

```bash
robot tests
```
