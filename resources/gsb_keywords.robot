*** Settings ***
Resource    ../resources/thinker_keywords.robot
Resource    ../resources/retry_keywords.robot
Library     ../resources/customer_info_generators.py
Library     ../resources/verification_library.py
Library     ../resources/answers.py
Variables    ../scenarios.py
Variables    ../vars.yaml

*** Keywords ***
Initial GSB Lead Workflow
    [Arguments]    ${scenario}
    Log    --- Starting Initial GSB Lead Workflow: ${scenario['test_id']} ---

    ${customer_info_national_id_answer}=    Build Unique Customer Info Answer

    Log    Step 1: Logging in...
    ${session_id}=    Login    email=${email}    password=${password}
    Should Not Be Empty    ${session_id}
    Log    Step 1: Login successful.

    Log    Step 2: Applying for Product...
    ${case_id}=    Apply For Product    ${session_id}    ${scenario['product_name']}
    Should Not Be Empty    ${case_id}
    Log    Step 2: Product applied. Case ID: ${case_id}

    Log    Step 3: Answering Initial Questions...
    Answer Questions    ${session_id}    ${case_id}    ${customer_info_national_id_answer}
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['initial_questions']}
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['campaign_select_questions']}
    Log    Step 3: Initial Questions answered.

    Log    Step 4: Submitting Case...
    Submit Case    ${session_id}    ${case_id}
    Log    Step 4: Case submitted.

    Log    Step 5: Verifying Case Details (Pre-Approved)...
    Sleep    5s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    ${case_detail}=    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Customer Decision Unknown    ${session_id}    ${case_id}
    
    Verify Customer Data Field    ${case_detail}    thinker.loanStatus    PRE-APPROVED
    
    ${verifying_field_list_length}=    Get Length    ${case_detail['verifying_field_list']}
    Should Be True     ${verifying_field_list_length} > 0    verifying_field_list should not be empty
    Log    Step 5: Case Details verified (PRE-APPROVED).

    RETURN    ${session_id}    ${case_id}

GSB Lead Workflow
    [Arguments]    ${scenario}
    ${session_id}    ${case_id}=    Initial GSB Lead Workflow    ${scenario}

    Log    Step 6: Answering Secondary Questions...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['secondary_questions']}
    Log    Step 6: Secondary Questions answered.

    Log    Step 7: Verifying Case Details (Loan Status APPROVED)...
    Sleep    10s
    ${timeout}=    Set Variable    30s
    ${retry_interval}=    Set Variable    7s
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Approved Status for GSB Lead    ${session_id}    ${case_id}
    Log    Step 7: Loan Status is APPROVED verified.

    Log    Step 8: Customer Decision...
    Answer Questions    ${session_id}    ${case_id}    ${scenario['answers']['customer_decision']}
    Log    Step 8: Customer Decision answered.

    Log    Step 9: Completed Status...
    Sleep    10s
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Check Completed Status for GSB Lead    ${session_id}    ${case_id}    ${scenario}
    Log    Step 9: Completed Status verified.

    Log    Step 10: Booking Detail...
    Sleep    5s
    ${booking_detail}=    Get Booking Detail    ${session_id}    ${case_id}
    Should Not Be Empty    ${booking_detail}
    Should Be Equal As Strings    ${booking_detail['latest_status']}    COMPLETED
    Log    Step 10: Booking Detail retrieved.