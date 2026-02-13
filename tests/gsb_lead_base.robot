*** Settings ***
Resource    ../resources/gsb_keywords.robot
Resource    ../resources/global_setup.robot
Suite Setup    Create Thinker Session

*** Test Cases ***
Run GSB Lead P-Loan Base Scenario
    GSB Lead Workflow    ${GSB_LEAD_P_LOAN_BASE_SCENARIO}

Run GSB Lead Nano-Loan Base Scenario
    GSB Lead Workflow    ${GSB_LEAD_NANO_LOAN_BASE_SCENARIO}